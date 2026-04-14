`timescale 1ns/1ps

module DAC_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_8bit dut (
        .din(din),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: Minimum Value (0x00)", test_num);
        din = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Maximum Value (0xFF)", test_num);
        din = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Midpoint Value (0x80)", test_num);
        din = 8'h80;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Boundary High (0xFE)", test_num);
        din = 8'hFE;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Boundary Low (0x01)", test_num);
        din = 8'h01;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Alternating Bits Pattern 1 (0x55)", test_num);
        din = 8'h55;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Alternating Bits Pattern 2 (0xAA)", test_num);
        din = 8'hAA;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Random Data (0x3C)", test_num);
        din = 8'h3C;
        #1;

        check_outputs(8'h3C);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Random Data (0xA5)", test_num);
        din = 8'hA5;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Walking Ones (Bit 4)", test_num);
        din = 8'b00010000;
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_8bit Testbench");
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
        input [7:0] expected_dout;
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
