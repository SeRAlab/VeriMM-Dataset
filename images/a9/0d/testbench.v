`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg branch;
    reg [31:0] iaddr;
    reg [15:0] imm16;
    reg [25:0] imm26;
    reg [31:0] ins;
    reg [31:0] jiaddr;
    reg jump;
    wire [31:0] niaddr;
    wire [31:0] riaddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch(branch),
        .iaddr(iaddr),
        .imm16(imm16),
        .imm26(imm26),
        .ins(ins),
        .jiaddr(jiaddr),
        .jump(jump),
        .niaddr(niaddr),
        .riaddr(riaddr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Sequential Execution (PC + 4)", test_num);

            iaddr = 32'h00400000;
            branch = 0;
            jump = 0;
            ins = 32'h00000000;
            imm16 = 16'h0000;
            imm26 = 26'h0000000;
            jiaddr = 32'h00000000;


            #1;



            check_outputs(32'h00400004, 32'h00400004);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Branch Taken (Positive Offset)", test_num);

            iaddr = 32'h00400000;
            branch = 1;
            jump = 0;
            imm16 = 16'h0005;

            #1;


            check_outputs(32'h00400018, 32'h00400004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Branch Taken (Negative Offset)", test_num);

            iaddr = 32'h00400008;
            branch = 1;
            jump = 0;
            imm16 = 16'hFFFE;

            #1;


            check_outputs(32'h00400004, 32'h0040000C);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: J (Jump Direct)", test_num);

            iaddr = 32'h00400000;
            branch = 0;
            jump = 1;
            ins = 32'h08000001;
            imm26 = 26'h0000001;

            #1;


            check_outputs(32'h00000004, 32'h00400004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: JAL (Jump and Link)", test_num);

            iaddr = 32'h00400000;
            branch = 0;
            jump = 1;
            ins = 32'h0C000100;
            imm26 = 26'h0000100;

            #1;


            check_outputs(32'h00000400, 32'h00400004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: JR (Jump Register)", test_num);

            iaddr = 32'h00400000;
            branch = 0;
            jump = 1;
            ins = 32'h00000008;
            jiaddr = 32'h12345678;

            #1;


            check_outputs(32'h12345678, 32'h00400004);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: JALR (Jump and Link Register)", test_num);

            iaddr = 32'h00400000;
            branch = 0;
            jump = 1;
            ins = 32'h00000009;
            jiaddr = 32'hABCDEF00;

            #1;


            check_outputs(32'hABCDEF00, 32'h00400004);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Jump with PC Boundary", test_num);

            iaddr = 32'hF0400000;
            branch = 0;
            jump = 1;
            ins = 32'h08000005;
            imm26 = 26'h0000005;


            #1;



            check_outputs(32'hF0000014, 32'hF0400004);
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
        input [31:0] expected_niaddr;
        input [31:0] expected_riaddr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_niaddr === (expected_niaddr ^ niaddr ^ expected_niaddr) &&
                expected_riaddr === (expected_riaddr ^ riaddr ^ expected_riaddr)) begin
                $display("PASS");
                $display("  Outputs: niaddr=%h, riaddr=%h",
                         niaddr, riaddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: niaddr=%h, riaddr=%h",
                         expected_niaddr, expected_riaddr);
                $display("  Got:      niaddr=%h, riaddr=%h",
                         niaddr, riaddr);
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
