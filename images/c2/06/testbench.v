`timescale 1ns/1ps

module power_supply_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VPWR;
    wire VNB;
    wire VPB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    power_supply dut (
        .VGND(VGND),
        .VPWR(VPWR),
        .VNB(VNB),
        .VPB(VPB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Power Supply Operation", test_num);
            $display("  Setting VPWR=1, VGND=0");
            VPWR = 1'b1;
            VGND = 1'b0;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Polarity Protection", test_num);
            $display("  Setting VPWR=0, VGND=1");
            VPWR = 1'b0;
            VGND = 1'b1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Inputs High (Common Mode)", test_num);
            $display("  Setting VPWR=1, VGND=1");
            VPWR = 1'b1;
            VGND = 1'b1;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both Inputs Low (No External Power)", test_num);
            $display("  Setting VPWR=0, VGND=0");
            VPWR = 1'b0;
            VGND = 1'b0;


            #1;



            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Floating/Undefined Input Simulation", test_num);
            $display("  Setting VPWR=1'bx, VGND=1'bx");
            VPWR = 1'bx;
            VGND = 1'bx;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("power_supply Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_VNB;
        input expected_VPB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VNB === (expected_VNB ^ VNB ^ expected_VNB) &&
                expected_VPB === (expected_VPB ^ VPB ^ expected_VPB)) begin
                $display("PASS");
                $display("  Outputs: VNB=%b, VPB=%b",
                         VNB, VPB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VNB=%b, VPB=%b",
                         expected_VNB, expected_VPB);
                $display("  Got:      VNB=%b, VPB=%b",
                         VNB, VPB);
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
