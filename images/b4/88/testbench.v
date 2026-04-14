`timescale 1ns/1ps

module gray_code_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire [2:0] gray_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gray_code_counter_3bit dut (
        .clk(clk),
        .rst_n(rst_n),
        .gray_code(gray_code)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset state check");
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single step (0 -> 1)");
            reset_dut();
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Three steps (0 -> 1 -> 3 -> 2)");
            reset_dut();
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Five steps (middle of sequence)");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;


            #1;



            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full cycle check (8 steps)");
            reset_dut();
            repeat(8) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Boundary check (7 steps)");
            reset_dut();
            repeat(7) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Multiple wraps check (17 steps)");
            reset_dut();
            repeat(17) @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gray_code_counter_3bit Testbench");
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
        input [2:0] expected_gray_code;
        begin
            if (expected_gray_code === (expected_gray_code ^ gray_code ^ expected_gray_code)) begin
                $display("PASS");
                $display("  Outputs: gray_code=%h",
                         gray_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_code=%h",
                         expected_gray_code);
                $display("  Got:      gray_code=%h",
                         gray_code);
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
        $dumpvars(0,clk, rst_n, gray_code);
    end

endmodule
