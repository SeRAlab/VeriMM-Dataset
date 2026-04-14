`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] din;
    reg [5:0] in_size;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .in_size(in_size),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=2, positive", test_num);
        din = 32'h0000_0001;
        in_size = 6'd2;
        #1;

        check_outputs(32'h0000_0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=2, negative", test_num);
        din = 32'h0000_0003;
        in_size = 6'd2;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=4, positive", test_num);
        din = 32'h0000_0007;
        in_size = 6'd4;
        #1;

        check_outputs(32'h0000_0007);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=4, negative", test_num);
        din = 32'h0000_0008;
        in_size = 6'd4;
        #1;

        check_outputs(32'hFFFF_FFF8);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=8, positive", test_num);
        din = 32'h0000_007F;
        in_size = 6'd8;
        #1;

        check_outputs(32'h0000_007F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=8, negative", test_num);
        din = 32'h0000_0080;
        in_size = 6'd8;
        #1;

        check_outputs(32'hFFFF_FF80);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=16, positive", test_num);
        din = 32'h0000_55AA;
        in_size = 6'd16;
        #1;

        check_outputs(32'h0000_55AA);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=16, negative", test_num);
        din = 32'h0000_8001;
        in_size = 6'd16;
        #1;

        check_outputs(32'hFFFF_8001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: size=32", test_num);
        din = 32'hDEAD_BEEF;
        in_size = 6'd32;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: unrecognized size 1", test_num);
        din = 32'hFFFF_FFFF;
        in_size = 6'd1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: unrecognized size 10", test_num);
        din = 32'hFFFF_FFFF;
        in_size = 6'd10;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: unrecognized size 0", test_num);
        din = 32'h1234_5678;
        in_size = 6'd0;
        #1;

        check_outputs(32'h0000_0000);
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
        testcase011();
        testcase012();
        
        
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
