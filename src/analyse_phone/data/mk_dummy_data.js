const fs = require('fs');
const path = require('path');
const randSum = (max) => Math.floor((Math.random() + Math.random()) / 2 * max);

fs.readdir('.', {withFileTypes: true}, (err, dirents) => {
    if (err) throw err;

    for (const dirent of dirents) {
      const fp = path.join('.', dirent.name);
      if (dirent.isDirectory()) {
        fs.readdir(fp, (err, files) => {
          for (const file of files) {
            const csv_path = path.join('.', fp, file);
            let row_number = randSum(100);
            const splited = file.split('_');
            const s = splited[0];
            const d_arg = '2019/' + s.slice(0, 2) + "/" + s.slice(2)
            const d = new Date(d_arg);
            const dayOfWeek = d.getDay();
            if (dayOfWeek === 6 || dayOfWeek === 0) {
              // 土日にあたる回数のときは行数を減らす
              row_number = randSum(40);
            } else {
              row_number = randSum(120);
            }

            for (let i = 0; i < row_number; i++) {
              let rand_time;
              if (file.startsWith('+8150')) {
                rand_time = randSum(20);
              } else {
                rand_time = randSum(28);
              }
              if (rand_time == 0) {
                rand_time = 1;
              }
              if (i === 0) {
                // 初期化
                fs.writeFileSync(csv_path, "CFxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx," + rand_time + "\n");
              } else {
                fs.appendFileSync(csv_path, "CFxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx," + rand_time + "\n");
              }
            }
          }
        })
      }
    }
});
