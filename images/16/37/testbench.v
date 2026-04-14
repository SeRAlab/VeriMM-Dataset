`timescale 1ns/1ps

module cholesky_decomposition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] matrix_in;
    wire [3:0] l_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cholesky_decomposition dut (
        .clk(clk),
        .matrix_in(matrix_in),
        .l_out(l_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            matrix_in <= 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            matrix_in <= 4'b1001;
            repeat(2) @(posedge clk);
            $display("Test %0d: Identity Matrix [1 0; 0 1]", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            matrix_in <= 4'b1111;
            repeat(2) @(posedge clk);
            $display("Test %0d: All-ones Matrix [1 1; 1 1]", test_num);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            matrix_in <= 4'b1000;
            repeat(2) @(posedge clk);
            $display("Test %0d: Diagonal Matrix [1 0; 0 0]", test_num);
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            matrix_in <= 4'b0000;
            repeat(2) @(posedge clk);
            $display("Test %0d: Zero Matrix", test_num);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cholesky_decomposition Testbench");
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
        input [3:0] expected_l_out;
        begin
            if (expected_l_out === (expected_l_out ^ l_out ^ expected_l_out)) begin
                $display("PASS");
                $display("  Outputs: l_out=%h",
                         l_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l_out=%h",
                         expected_l_out);
                $display("  Got:      l_out=%h",
                         l_out);
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
        $dumpvars(0,clk, matrix_in, l_out);
    end

endmodule
