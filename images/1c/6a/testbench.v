`timescale 1ns/1ps

module aes_256_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] data_in;
    reg [255:0] key;
    reg rst;
    reg start;
    wire [255:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_256 dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .rst(rst),
        .start(start),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 0;
            key = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nRunning testcase%03d: All Zeros Data and Key", test_num);
            reset_dut();
            data_in = 256'h0;
            key     = 256'h0;
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done === 1);
            @(posedge clk);



            #1;




            check_outputs(256'hDC95C078A240898953AD0F5F6825FD0BE9170E3A9D1271D5A64287B94B245591, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nRunning testcase%03d: All Ones Data and Key", test_num);
            reset_dut();
            data_in = {256{1'b1}};
            key     = {256{1'b1}};
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1);
            @(posedge clk);


            #1;



            check_outputs(256'h777995A2E8DC7D77F120610531522F5590918731362799308F1E500F9444B27B, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nRunning testcase%03d: Alternating Bits (5s and As)", test_num);
            reset_dut();
            data_in = 256'h5555555555555555555555555555555555555555555555555555555555555555;
            key     = 256'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1);
            @(posedge clk);


            #1;



            check_outputs(256'h62F9B89280F060667B7A66786F8089456722248590123456789ABCDEFF012345, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nRunning testcase%03d: Mixed Hex Pattern", test_num);
            reset_dut();
            data_in = 256'h00112233445566778899AABBCCDDEEFF00112233445566778899AABBCCDDEEFF;
            key     = 256'h000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done === 1);
            @(posedge clk);


            #1;



            check_outputs(256'h8EA2B7CA516745BFEAFC49904B496089B3250247BD1D7AE50080808080808080, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_256 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [255:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, data_in, key, rst, start, data_out, done);
    end

endmodule
