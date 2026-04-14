`timescale 1ns/1ps

module matrix_inversion_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg [3:0] matrix_in;
    wire [3:0] matrix_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inversion dut (
        .clk(clk),
        .en(en),
        .matrix_in(matrix_in),
        .matrix_out(matrix_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            matrix_in = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity Matrix [1,0;0,1]", test_num);
            reset_dut();
            matrix_in = 4'b1001;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Matrix (Singular)", test_num);
            reset_dut();
            matrix_in = 4'b0000;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Permutation Matrix [0,1;1,0]", test_num);
            reset_dut();
            matrix_in = 4'b0110;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All-ones Matrix (Singular)", test_num);
            reset_dut();
            matrix_in = 4'b1111;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper Triangular [1,1;0,1]", test_num);
            reset_dut();
            matrix_in = 4'b1101;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Non-singular [0,1;1,1]", test_num);
            reset_dut();
            matrix_in = 4'b0111;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Non-singular [1,1;1,0]", test_num);
            reset_dut();
            matrix_in = 4'b1110;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Row 2 Zero (Singular)", test_num);
            reset_dut();
            matrix_in = 4'b1100;
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
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
        $display("matrix_inversion Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_matrix_out;
        begin
            if (expected_matrix_out === (expected_matrix_out ^ matrix_out ^ expected_matrix_out)) begin
                $display("PASS");
                $display("  Outputs: matrix_out=%h",
                         matrix_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: matrix_out=%h",
                         expected_matrix_out);
                $display("  Got:      matrix_out=%h",
                         matrix_out);
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
        $dumpvars(0,clk, en, matrix_in, matrix_out);
    end

endmodule
