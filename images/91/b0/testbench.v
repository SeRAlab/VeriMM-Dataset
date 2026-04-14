`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [31:0] B;
    reg [1:0] ctrl;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 2'b00; ctrl = 2'b00; B = 32'h12345678;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 2'b01; ctrl = 2'b00; B = 32'h00000001;

        #1;


        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 2'b00; ctrl = 2'b01; B = 32'h00000001;

        #1;


        check_outputs(32'h00000002);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 2'b01; ctrl = 2'b01; B = 32'h0000000F;

        #1;


        check_outputs(32'h0000003C);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 2'b11; ctrl = 2'b00; B = 32'hFFFFFFFF;

        #1;


        check_outputs(32'hFFFFFFF8);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 2'b00; ctrl = 2'b11; B = 32'hAAAAAAAA;

        #1;


        check_outputs(32'h55555550);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 2'b10; ctrl = 2'b10; B = 32'h0000FFFF;

        #1;


        check_outputs(32'h000FFFF0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 2'b10; ctrl = 2'b11; B = 32'h0F0F0F0F;

        #1;


        check_outputs(32'hE1E1E1E0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 2'b11; ctrl = 2'b11; B = 32'h00000001;

        #1;


        check_outputs(32'h00000040);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 2'b11; ctrl = 2'b11; B = 32'hF0F0F0F0;


        #1;



        check_outputs(32'h3C3C3C00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
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
