`timescale 1ns/1ps

module simple_md5_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg rst;
    wire [127:0] hash_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_md5 dut (
        .clk(clk),
        .data_in(data_in),
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
            data_in = 128'b0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            reset_dut();
            data_in = 128'h00000000_00000000_00000000_00000000;

            repeat(64) @(posedge clk);

            #1;


            check_outputs(128'h770387532f84877716183d7350172900);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Input", test_num);
            reset_dut();
            data_in = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            repeat(64) @(posedge clk);
            #1;

            check_outputs(128'h6965681177656d091a182b132e185c0a);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 1010...", test_num);
            reset_dut();
            data_in = 128'hAAAAAAAAAAAAAAAA_AAAAAAAAAAAAAAAA;
            repeat(64) @(posedge clk);
            #1;

            check_outputs(128'h21153120150d1814141d011500091807);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 0101...", test_num);
            reset_dut();
            data_in = 128'h55555555_55555555_55555555_55555555;
            repeat(64) @(posedge clk);
            #1;

            check_outputs(128'h1b01232c1c3c2b292e100d02313a2a1b);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Incremental Byte Pattern", test_num);
            reset_dut();
            data_in = 128'h00010203_04050607_08090A0B_0C0D0E0F;
            repeat(64) @(posedge clk);
            #1;

            check_outputs(128'h070a00041d131a13180c130311020717);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit High (MSB)", test_num);
            reset_dut();
            data_in = 128'h80000000_00000000_00000000_00000000;
            repeat(64) @(posedge clk);
            #1;

            check_outputs(128'h361730040e3a1d072b220a2d21092e09);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Deadbeef Pattern", test_num);
            reset_dut();
            data_in = 128'hDEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF;
            repeat(64) @(posedge clk);
            #1;

            check_outputs(128'h1c1a3b1103322d3b2a2d1f032231013a);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_md5 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, data_in, rst, hash_out);
    end

endmodule
