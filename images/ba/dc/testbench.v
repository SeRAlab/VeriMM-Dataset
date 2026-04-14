`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] IR;
    reg [15:0] Ra;
    reg [15:0] Rb;
    reg [1:0] aluControl;
    wire [15:0] aluOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IR(IR),
        .Ra(Ra),
        .Rb(Rb),
        .aluControl(aluControl),
        .aluOut(aluOut)
    );
    task start_test;

        input [31:0] name;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: %s", test_num, name);
        end
        endtask

    task testcase001;

        begin
            start_test("Pass Ra (aluControl=0)");
            Ra = 16'hABCD;
            Rb = 16'h1234;
            IR = 6'b000000;
            aluControl = 2'b00;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            start_test("NOT Ra (aluControl=3)");
            Ra = 16'hF0F0;
            Rb = 16'hFFFF;
            IR = 6'b000000;
            aluControl = 2'b11;
            #1;

            check_outputs(16'h0F0F);
        end
        endtask

    task testcase003;

        begin
            start_test("ADD Ra + Rb (Register Mode)");
            Ra = 16'd100;
            Rb = 16'd250;
            IR = 6'b000000;
            aluControl = 2'b01;
            #1;

            check_outputs(16'd350);
        end
        endtask

    task testcase004;

        begin
            start_test("ADD Ra + Imm (Positive Immediate)");
            Ra = 16'h0010;
            Rb = 16'hFFFF;
            IR = 6'b100111;
            aluControl = 2'b01;
            #1;

            check_outputs(16'h0017);
        end
        endtask

    task testcase005;

        begin
            start_test("ADD Ra + Imm (Negative Immediate)");
            Ra = 16'h0010;
            Rb = 16'h0000;
            IR = 6'b111111;
            aluControl = 2'b01;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase006;

        begin
            start_test("AND Ra & Rb (Register Mode)");
            Ra = 16'hAAAA;
            Rb = 16'h5555;
            IR = 6'b000000;
            aluControl = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            start_test("AND Ra & Imm (Immediate Mode)");
            Ra = 16'hFFFF;
            Rb = 16'h0000;
            IR = 6'b101010;
            aluControl = 2'b10;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase008;

        begin
            start_test("ADD Overflow check");
            Ra = 16'hFFFF;
            Rb = 16'h0001;
            IR = 6'b000000;
            aluControl = 2'b01;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_aluOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluOut === (expected_aluOut ^ aluOut ^ expected_aluOut)) begin
                $display("PASS");
                $display("  Outputs: aluOut=%h",
                         aluOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluOut=%h",
                         expected_aluOut);
                $display("  Got:      aluOut=%h",
                         aluOut);
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
