package dal

import (
	"bytelite/common/secu"
	"bytelite/etc"
	"context"
	"github.com/stretchr/testify/require"
	"github.com/zeromicro/go-zero/core/conf"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
	"os"
	"sync"
	"testing"
)

func builderModel() UsersModel {
	var model UsersModel
	once := sync.Once{}
	once.Do(func() {
		configFile := "etc/config_test.yaml"
		var c etc.Config
		conf.MustLoad(configFile, &c)
		conn := sqlx.NewMysql(c.DSN)
		model = NewUserModel(conn, c.Cache)
	})
	return model
}

func TestBasicInsert(t *testing.T) {
	if os.Getenv("CI") != "GITHUB" {
		t.Skip("skip")
	}
	model := builderModel()
	hashedPassword, salt := secu.GenHashedPassAndSalt("123456")
	result, err := model.Insert(context.Background(), &User{
		Username: "3",
		Password: hashedPassword,
		Salt:     salt,
	})
	require.NoError(t, err)
	lastInsertId, err := result.LastInsertId()
	require.NoError(t, err)
	require.NotZero(t, lastInsertId)
}