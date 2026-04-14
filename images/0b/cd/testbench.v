`timescale 1ns/1ps

module md5_hash_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    reg [127:0] hash_in;
    reg rst;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_hash dut (
        .clk(clk),
        .data_in(data_in),
        .hash_in(hash_in),
        .rst(rst),
        .hash_out(hash_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            hash_in = 0;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Block", test_num);
            reset_dut();

            data_in = 512'h0;
            hash_in = MD5_IV;


            repeat(100) @(posedge clk);


            #1;



            check_outputs(128'he2c420d928d4d468e42107939b727731);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern Block (0x01...)", test_num);
            reset_dut();


            data_in = {64{8'h01}};
            hash_in = MD5_IV;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(128'h3660569804e30467ed2a414169c84e27);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Custom IV and Mixed Data", test_num);
            reset_dut();


            hash_in = 128'hffffffff_eeeeeeee_dddddddd_cccccccc;

            data_in = 512'h0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;

            repeat(100) @(posedge clk);


            #1;



            check_outputs(128'h806085a86d9987621c1703e7e974910e);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Block", test_num);
            reset_dut();

            data_in = {512{1'b1}};
            hash_in = MD5_IV;

            repeat(100) @(posedge clk);

            #1;


            check_outputs(128'h0e90f63af390886695b2935260196839);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_hash Testbench");
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
        input [127:0] expected_hash_out;
        begin
            if (expected_hash_out === (expected_hash_out ^ hash_out ^ expected_hash_out)) begin
                $display("PASS");
                $display("  Outputs: hash_out=%h",
                         hash_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hash_out=%h",
                         expected_hash_out);
                $display("  Got:      hash_out=%h",
                         hash_out);
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
        $dumpvars(0,clk, data_in, hash_in, rst, hash_out);
    end

endmodule
