`timescale 1ns/1ps

module ldo_control_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [4:0] vin;
    wire [4:0] vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ldo_control dut (
        .control(control),
        .vin(vin),
        .vout(vout)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Control Low (Cut-off), Vin = 0", test_num);
        control = 1'b0;
        vin = 5'd0;
        #5;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Control Low (Cut-off), Vin = Max (31)", test_num);
        control = 1'b0;
        vin = 5'd31;
        #5;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Control High (Regulated), Vin = 0", test_num);
        control = 1'b1;
        vin = 5'd0;
        #5;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Control High (Regulated), Vin = Mid (15)", test_num);
        control = 1'b1;
        vin = 5'd15;
        #5;
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Control High (Regulated), Vin = Max (31)", test_num);
        control = 1'b1;
        vin = 5'd31;
        #5;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Switching from High to Low, Vin = 20", test_num);

        control = 1'b1;
        vin = 5'd20;
        #5;

        control = 1'b0;
        #5;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Switching from Low to High, Vin = 10", test_num);

        control = 1'b0;
        vin = 5'd10;
        #5;

        control = 1'b1;
        #5;
        #1;

        check_outputs(5'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ldo_control Testbench");
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
        input [4:0] expected_vout;
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
