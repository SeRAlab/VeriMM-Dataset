`timescale 1ns/1ps

module data_forwarding_unit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EX_dst;
    reg [4:0] ID_src1;
    reg [4:0] ID_src2;
    wire ForwardA;
    wire ForwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_unit dut (
        .EX_dst(EX_dst),
        .ID_src1(ID_src1),
        .ID_src2(ID_src2),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: No data hazard", test_num);
            EX_dst  = 5'd5;
            ID_src1 = 5'd1;
            ID_src2 = 5'd2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Hazard on Source 1", test_num);
            EX_dst  = 5'd10;
            ID_src1 = 5'd10;
            ID_src2 = 5'd5;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Hazard on Source 2", test_num);
            EX_dst  = 5'd15;
            ID_src1 = 5'd4;
            ID_src2 = 5'd15;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Hazard on both Source 1 and Source 2", test_num);
            EX_dst  = 5'd20;
            ID_src1 = 5'd20;
            ID_src2 = 5'd20;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Register 0 check (No forwarding for reg 0)", test_num);
            EX_dst  = 5'd0;
            ID_src1 = 5'd0;
            ID_src2 = 5'd0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Maximum register index (31) hazard", test_num);
            EX_dst  = 5'd31;
            ID_src1 = 5'd31;
            ID_src2 = 5'd10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_unit Testbench");
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
        input expected_ForwardA;
        input expected_ForwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ForwardA === (expected_ForwardA ^ ForwardA ^ expected_ForwardA) &&
                expected_ForwardB === (expected_ForwardB ^ ForwardB ^ expected_ForwardB)) begin
                $display("PASS");
                $display("  Outputs: ForwardA=%b, ForwardB=%b",
                         ForwardA, ForwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ForwardA=%b, ForwardB=%b",
                         expected_ForwardA, expected_ForwardB);
                $display("  Got:      ForwardA=%b, ForwardB=%b",
                         ForwardA, ForwardB);
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
