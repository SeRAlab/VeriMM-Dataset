`timescale 1ns/1ps

module voltage_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Vin;
    reg [4:0] Vref;
    wire Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    voltage_comparator dut (
        .Vin(Vin),
        .Vref(Vref),
        .Vout(Vout)
    );
    task testcase001;

    begin
        test_num = 1;
        Vin = 5'd0;
        Vref = 5'd0;
        $display("Test %0d: Vin=%d, Vref=%d (Equality Check)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Vin = 5'd10;
        Vref = 5'd5;
        $display("Test %0d: Vin=%d, Vref=%d (Vin > Vref)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Vin = 5'd5;
        Vref = 5'd10;
        $display("Test %0d: Vin=%d, Vref=%d (Vin < Vref)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Vin = 5'd31;
        Vref = 5'd0;
        $display("Test %0d: Vin=%d, Vref=%d (Maximum Vin vs Minimum Vref)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Vin = 5'd0;
        Vref = 5'd31;
        $display("Test %0d: Vin=%d, Vref=%d (Minimum Vin vs Maximum Vref)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Vin = 5'd31;
        Vref = 5'd31;
        $display("Test %0d: Vin=%d, Vref=%d (Both Maximum)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Vin = 5'd16;
        Vref = 5'd15;
        $display("Test %0d: Vin=%d, Vref=%d (Boundary Vin = Vref + 1)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Vin = 5'd15;
        Vref = 5'd16;
        $display("Test %0d: Vin=%d, Vref=%d (Boundary Vin = Vref - 1)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Vin = 5'd25;
        Vref = 5'd12;
        $display("Test %0d: Vin=%d, Vref=%d (Random comparison)", test_num, Vin, Vref);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        Vin = 5'd7;
        Vref = 5'd28;
        $display("Test %0d: Vin=%d, Vref=%d (Random comparison)", test_num, Vin, Vref);
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
        $display("voltage_comparator Testbench");
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
        input expected_Vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%b",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%b",
                         expected_Vout);
                $display("  Got:      Vout=%b",
                         Vout);
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
