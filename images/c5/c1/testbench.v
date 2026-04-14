`timescale 1ns/1ps

module xor_gate_tb;

    // Testbench signals (combinational circuit)
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire XOR_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor_gate dut (
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .XOR_output(XOR_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: VPB=0, VNB=0", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b0;
            VNB  = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: VPB=0, VNB=1", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b0;
            VNB  = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: VPB=1, VNB=0", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b1;
            VNB  = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: VPB=1, VNB=1", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b1;
            VNB  = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: VPB=0, VNB=1 (Different Power Rails)", test_num);
            VPWR = 1'b0;
            VGND = 1'b1;
            VPB  = 1'b0;
            VNB  = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: VPB=1, VNB=1 (Checking logic stability)", test_num);
            VPWR = 1'b1;
            VGND = 1'b0;
            VPB  = 1'b1;
            VNB  = 1'b1;
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
        $display("xor_gate Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_XOR_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_XOR_output === (expected_XOR_output ^ XOR_output ^ expected_XOR_output)) begin
                $display("PASS");
                $display("  Outputs: XOR_output=%b",
                         XOR_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: XOR_output=%b",
                         expected_XOR_output);
                $display("  Got:      XOR_output=%b",
                         XOR_output);
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
