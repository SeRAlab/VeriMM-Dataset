`timescale 1ns/1ps

module gray_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [2:0] gray_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_counter dut (
        .clk(clk),
        .gray_count(gray_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");

            repeat(8) begin
                if (gray_count === 3'b000) begin

                end else begin
                    @(posedge clk);
                end
            end
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: 1 Cycle - Expected: 001", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: 2 Cycles - Expected: 011", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: 3 Cycles - Expected: 010", test_num);
            reset_dut();
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: 4 Cycles - Expected: 110", test_num);
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: 5 Cycles - Expected: 111", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: 6 Cycles - Expected: 101", test_num);
            reset_dut();
            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: 7 Cycles - Expected: 100", test_num);
            reset_dut();
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: 8 Cycles (Full Wrap) - Expected: 000", test_num);
            reset_dut();
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: 10 Cycles (Wrap + 2) - Expected: 011", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_counter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [2:0] expected_gray_count;
        begin
            if (expected_gray_count === (expected_gray_count ^ gray_count ^ expected_gray_count)) begin
                $display("PASS");
                $display("  Outputs: gray_count=%h",
                         gray_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_count=%h",
                         expected_gray_count);
                $display("  Got:      gray_count=%h",
                         gray_count);
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
        $dumpvars(0,clk, gray_count);
    end

endmodule
