`timescale 1ns/1ps

module counter_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] load_value;
    reg reset;
    wire [15:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_16bit dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            load_value = 16'h0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Verification", test_num);
            reset_dut();

            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Up Counting (10 cycles)", test_num);
            reset_dut();

            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load Value Check", test_num);
            reset_dut();
            load_value = 16'hABCD;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Increment After Load", test_num);
            reset_dut();
            load_value = 16'h1000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(16'h1005);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Counter Wrap-around", test_num);
            reset_dut();
            load_value = 16'hFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset Priority Over Load", test_num);
            reset_dut();
            reset = 1;
            load = 1;
            load_value = 16'h5555;
            @(posedge clk);
            #1 reset = 0;
            load = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, load, load_value, reset, count);
    end

endmodule
