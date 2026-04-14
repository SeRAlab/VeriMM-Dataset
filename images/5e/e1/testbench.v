`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] EXMEMRd;
    reg EXMEMRegWr;
    reg [4:0] IDEXRd;
    reg IDEXRegWr;
    reg [4:0] IDEXRs;
    reg [4:0] IDEXRt;
    reg [4:0] IFIDRs;
    reg [4:0] IFIDRt;
    reg [4:0] MEMWBRd;
    reg MEMWBRegWr;
    wire [1:0] forward1;
    wire [1:0] forward2;
    wire [1:0] forwardA;
    wire [1:0] forwardB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EXMEMRd(EXMEMRd),
        .EXMEMRegWr(EXMEMRegWr),
        .IDEXRd(IDEXRd),
        .IDEXRegWr(IDEXRegWr),
        .IDEXRs(IDEXRs),
        .IDEXRt(IDEXRt),
        .IFIDRs(IFIDRs),
        .IFIDRt(IFIDRt),
        .MEMWBRd(MEMWBRd),
        .MEMWBRegWr(MEMWBRegWr),
        .forward1(forward1),
        .forward2(forward2),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No hazards", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;

            #1;


            check_outputs(2'b00, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: EX Hazard forwardA", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;


            IDEXRs = 5'd5;
            EXMEMRd = 5'd5;
            EXMEMRegWr = 1'b1;

            #1;


            check_outputs(2'b00, 2'b00, 2'b10, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: EX Hazard forwardB", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;


            IDEXRt = 5'd10;
            EXMEMRd = 5'd10;
            EXMEMRegWr = 1'b1;

            #1;


            check_outputs(2'b00, 2'b00, 2'b00, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MEM Hazard forwardA", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;


            IDEXRs = 5'd7;
            MEMWBRd = 5'd7;
            MEMWBRegWr = 1'b1;

            #1;


            check_outputs(2'b00, 2'b00, 2'b01, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: MEM Hazard forwardB", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;


            IDEXRt = 5'd12;
            MEMWBRd = 5'd12;
            MEMWBRegWr = 1'b1;

            #1;


            check_outputs(2'b00, 2'b00, 2'b00, 2'b01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Double Hazard Priority (forwardA)", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;


            IDEXRs = 5'd3;
            EXMEMRd = 5'd3;
            MEMWBRd = 5'd3;
            EXMEMRegWr = 1'b1;
            MEMWBRegWr = 1'b1;


            #1;



            check_outputs(2'b00, 2'b00, 2'b10, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Register 0 hazard check", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;

            IDEXRs = 5'd0;
            EXMEMRd = 5'd0;
            EXMEMRegWr = 1'b1;


            #1;



            check_outputs(2'b00, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IF stage hazard from ID/EX", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;

            IFIDRs = 5'd15;
            IDEXRd = 5'd15;
            IDEXRegWr = 1'b1;

            #1;


            check_outputs(2'b01, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IF stage hazard from EX/MEM", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;

            IFIDRt = 5'd20;
            EXMEMRd = 5'd20;
            EXMEMRegWr = 1'b1;

            #1;


            check_outputs(2'b00, 2'b10, 2'b00, 2'b00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IF stage hazard from MEM/WB", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;

            IFIDRs = 5'd25;
            MEMWBRd = 5'd25;
            MEMWBRegWr = 1'b1;

            #1;


            check_outputs(2'b11, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: IF stage priority (closest stage wins)", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;

            IFIDRs = 5'd4;
            IDEXRd = 5'd4;
            EXMEMRd = 5'd4;
            MEMWBRd = 5'd4;
            IDEXRegWr = 1'b1;
            EXMEMRegWr = 1'b1;
            MEMWBRegWr = 1'b1;


            #1;



            check_outputs(2'b01, 2'b00, 2'b00, 2'b00);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous hazards in IF and EX stages", test_num);

            IFIDRs = 0; IFIDRt = 0; IDEXRs = 0; IDEXRt = 0; IDEXRd = 0;
            EXMEMRd = 0; MEMWBRd = 0; IDEXRegWr = 0; EXMEMRegWr = 0; MEMWBRegWr = 0;


            IDEXRs = 5'd1;
            EXMEMRd = 5'd1;
            EXMEMRegWr = 1'b1;


            IFIDRt = 5'd2;
            MEMWBRd = 5'd2;
            MEMWBRegWr = 1'b1;

            #1;


            check_outputs(2'b00, 2'b11, 2'b10, 2'b00);
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
        input [1:0] expected_forward1;
        input [1:0] expected_forward2;
        input [1:0] expected_forwardA;
        input [1:0] expected_forwardB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_forward1 === (expected_forward1 ^ forward1 ^ expected_forward1) &&
                expected_forward2 === (expected_forward2 ^ forward2 ^ expected_forward2) &&
                expected_forwardA === (expected_forwardA ^ forwardA ^ expected_forwardA) &&
                expected_forwardB === (expected_forwardB ^ forwardB ^ expected_forwardB)) begin
                $display("PASS");
                $display("  Outputs: forward1=%h, forward2=%h, forwardA=%h, forwardB=%h",
                         forward1, forward2, forwardA, forwardB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: forward1=%h, forward2=%h, forwardA=%h, forwardB=%h",
                         expected_forward1, expected_forward2, expected_forwardA, expected_forwardB);
                $display("  Got:      forward1=%h, forward2=%h, forwardA=%h, forwardB=%h",
                         forward1, forward2, forwardA, forwardB);
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
