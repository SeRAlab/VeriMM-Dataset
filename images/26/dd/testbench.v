`timescale 1ns/1ps

module comb_logic_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comb_logic dut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'h00; B = 8'h00; C = 8'h00;
        #10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'hFF; B = 8'hFF; C = 8'hFF;
        #10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'h00; B = 8'h00; C = 8'hFF;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'hAA; B = 8'hFF; C = 8'hFF;
        #10;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'h55; B = 8'hAA; C = 8'hFF;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'h00; B = 8'h00; C = 8'h55;
        #10;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'hF0; B = 8'hCC; C = 8'hAA;
        #10;
        #1;

        check_outputs(8'hD5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'h0F; B = 8'hF0; C = 8'hF0;
        #10;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comb_logic Testbench");
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
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
