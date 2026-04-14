`timescale 1ns/1ps

module binary_to_bcd_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] binary_in;
    reg clk;
    reg en;
    wire [11:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_bcd dut (
        .binary_in(binary_in),
        .clk(clk),
        .en(en),
        .bcd_out(bcd_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            binary_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Input 0", test_num);
            binary_in = 10'd0;
            en = 1;
            @(posedge clk);
            en = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Input 123", test_num);
            binary_in = 10'd123;
            en = 1;
            @(posedge clk);
            en = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Input 999", test_num);
            binary_in = 10'd999;
            en = 1;
            @(posedge clk);
            en = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(12'h999);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Input 512", test_num);
            binary_in = 10'd512;
            en = 1;
            @(posedge clk);
            en = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(12'h512);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Input 45", test_num);
            binary_in = 10'd45;
            en = 1;
            @(posedge clk);
            en = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(12'h045);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Input 7", test_num);
            binary_in = 10'd7;
            en = 1;
            @(posedge clk);
            en = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(12'h007);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test %0d: Input 1023 (Truncated to 12-bit BCD)", test_num);
            binary_in = 10'd1023;
            en = 1;
            @(posedge clk);
            en = 0;
            repeat (15) @(posedge clk);
            #1;

            check_outputs(12'h023);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_bcd Testbench");
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
        input [11:0] expected_bcd_out;
        begin
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h",
                         bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h",
                         expected_bcd_out);
                $display("  Got:      bcd_out=%h",
                         bcd_out);
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
        $dumpvars(0,binary_in, clk, en, bcd_out);
    end

endmodule
