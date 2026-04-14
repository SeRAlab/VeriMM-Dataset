`timescale 1ns/1ps

module switching_regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] vin;
    reg [7:0] vref;
    wire [7:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    switching_regulator dut (
        .vin(vin),
        .vref(vref),
        .vout(vout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: vin=4, vref=2 (vin > vref, in range)", test_num);
        vin = 8'd4;
        vref = 8'd2;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: vin=1, vref=3 (vin < vref, in range)", test_num);
        vin = 8'd1;
        vref = 8'd3;
        #1;

        check_outputs(8'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: vin=2, vref=2 (vin == vref, in range)", test_num);
        vin = 8'd2;
        vref = 8'd2;
        #1;

        check_outputs(8'd2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: vin=10, vref=2 (vin > vref, exceeds 5V)", test_num);
        vin = 8'd10;
        vref = 8'd2;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: vin=2, vref=15 (vref > vin, exceeds 5V)", test_num);
        vin = 8'd2;
        vref = 8'd15;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: vin=100, vref=50 (Both > 5V, vin > vref)", test_num);
        vin = 8'd100;
        vref = 8'd50;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: vin=0, vref=0 (Minimum values)", test_num);
        vin = 8'd0;
        vref = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: vin=5, vref=5 (At clamp limit)", test_num);
        vin = 8'd5;
        vref = 8'd5;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: vin=255, vref=255 (Maximum 8-bit values)", test_num);
        vin = 8'd255;
        vref = 8'd255;
        #1;

        check_outputs(8'd5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: vin=7, vref=6 (Both > 5V, vin slightly > vref)", test_num);
        vin = 8'd7;
        vref = 8'd6;
        #1;

        check_outputs(8'd5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("switching_regulator Testbench");
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
        input [7:0] expected_vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: vout=%h",
                         vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vout=%h",
                         expected_vout);
                $display("  Got:      vout=%h",
                         vout);
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
