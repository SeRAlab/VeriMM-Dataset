`timescale 1ns/1ps

module down_preset_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] preset;
    reg reset;
    wire [6:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    down_preset_counter dut (
        .clk(clk),
        .preset(preset),
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
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 64 and count down twice", test_num);
            preset = 7'b100_0000;
            reset_dut();
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'b011_1110);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0 and count down to wrap to 127", test_num);
            preset = 7'd0;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd127);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 5 and count down 10 times", test_num);
            preset = 7'd5;
            reset_dut();
            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd123);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 127 and count down once", test_num);
            preset = 7'b111_1111;
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd126);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 50, count 5 times, then reload 20 and count twice", test_num);
            preset = 7'd50;
            reset_dut();
            repeat (5) @(posedge clk);

            preset = 7'd20;
            reset_dut();
            repeat (2) @(posedge clk);
            #1;
            #1;

            check_outputs(7'd18);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("down_preset_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [6:0] expected_count;
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
        $dumpvars(0,clk, preset, reset, count);
    end

endmodule
