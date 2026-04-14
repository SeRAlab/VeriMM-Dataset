`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg PCEN;
    reg PCSrc;
    reg RST;
    reg [31:0] inPC;
    wire [31:0] outPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .PCEN(PCEN),
        .PCSrc(PCSrc),
        .RST(RST),
        .inPC(inPC),
        .outPC(outPC)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            PCEN = 0;
            PCSrc = 0;
            inPC = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Increment (PC+4)", test_num);
            reset_dut();

            PCEN = 1;
            PCSrc = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Sequential Increments", test_num);
            reset_dut();

            PCEN = 1;
            PCSrc = 0;
            repeat(3) @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h0000000C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Branch/Jump to Input Address", test_num);
            reset_dut();

            PCEN = 1;
            PCSrc = 1;
            inPC = 32'hAABBCC00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(32'hAABBCC00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PC Enable Deactivated (Stall)", test_num);
            reset_dut();


            PCEN = 1;
            PCSrc = 0;
            @(posedge CLK);
            #1;


            PCEN = 0;
            repeat(2) @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h00000004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Jump followed by Increment", test_num);
            reset_dut();


            PCEN = 1;
            PCSrc = 1;
            inPC = 32'h00000100;
            @(posedge CLK);
            #1;


            PCSrc = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h00000104);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: PCSrc Priority Check", test_num);
            reset_dut();


            PCEN = 1;
            PCSrc = 1;
            inPC = 32'h5555AAAA;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(32'h5555AAAA);
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
        input [31:0] expected_outPC;
        begin
            if (expected_outPC === (expected_outPC ^ outPC ^ expected_outPC)) begin
                $display("PASS");
                $display("  Outputs: outPC=%h",
                         outPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outPC=%h",
                         expected_outPC);
                $display("  Got:      outPC=%h",
                         outPC);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,CLK, PCEN, PCSrc, RST, inPC, outPC);
    end

endmodule
