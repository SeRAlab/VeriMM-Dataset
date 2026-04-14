`timescale 1ns/1ps

module logic_function_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [3:0] din;
    reg rst;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_function dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: din = 4'b0000 (0 ones)", test_num);
            reset_dut();
            din = 4'b0000;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: din = 4'b0001 (1 one)", test_num);
            reset_dut();
            din = 4'b0001;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: din = 4'b1000 (1 one)", test_num);
            reset_dut();
            din = 4'b1000;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: din = 4'b0011 (2 ones)", test_num);
            reset_dut();
            din = 4'b0011;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: din = 4'b1010 (2 ones)", test_num);
            reset_dut();
            din = 4'b1010;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: din = 4'b0111 (3 ones)", test_num);
            reset_dut();
            din = 4'b0111;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: din = 4'b1110 (3 ones)", test_num);
            reset_dut();
            din = 4'b1110;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: din = 4'b1111 (4 ones)", test_num);
            reset_dut();
            din = 4'b1111;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: din = 4'b1001 (2 ones)", test_num);
            reset_dut();
            din = 4'b1001;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: din = 4'b0100 (1 one)", test_num);
            reset_dut();
            din = 4'b0100;
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logic_function Testbench");
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
        testcase010();
        
        
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
        input expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
                         dout);
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

endmodule
