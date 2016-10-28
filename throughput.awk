BEGIN{
  duration = 0.5;
  f0 = 0;
  f1 = 0;
  f2 = 0;
  f3 = 0;
  f4 = 0;
}
{
  event = $1;
  time = $2;
  src = $3;
  dst = $4;
  type = $5;
  size = $6;
  fid = $8;

  if(event == "r" && dst == 10){
      if(fid == 1){
        f0 += size;
      }
      else if(fid == 2){
        f1 += size;
      }
      else if(fid == 3){
        f2 += size;
      }
      else if(fid == 4){
        f3 += size;
      }
      else{
        f4 += size;
      }
  }

}
END{
  printf("Throughput from node 0 : %f Mbps in 0.5s\n", f0/0.5*8/1000000);
  printf("Throughput from node 1 : %f Mbps in 0.5s\n", f1/0.5*8/1000000);
  printf("Throughput from node 2 : %f Mbps in 0.5s\n", f2/0.5*8/1000000);
  printf("Throughput from node 3 : %f Mbps in 0.5s\n", f3/0.5*8/1000000);
  printf("Throughput from node 4 : %f Mbps in 0.5s\n", f4/0.5*8/1000000);
  printf("Average Throughput : %f Mbps in 0.5s\n", (f0/0.5*8/1000000 + f1/0.5*8/1000000 + f2/0.5*8/1000000 + f3/0.5*8/1000000 + f4/0.5*8/1000000) / 5);
}