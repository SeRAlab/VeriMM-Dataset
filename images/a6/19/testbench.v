`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Din0;
    reg [7:0] Din1;
    reg [7:0] Din2;
    reg [7:0] Din3;
    reg [7:0] Din4;
    reg [7:0] Din5;
    reg [7:0] Din6;
    reg [7:0] Din7;
    wire [7:0] Flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din0(Din0),
        .Din1(Din1),
        .Din2(Din2),
        .Din3(Din3),
        .Din4(Din4),
        .Din5(Din5),
        .Din6(Din6),
        .Din7(Din7),
        .Flag(Flag)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No inputs match Din0", test_num);
        Din0 = 8'hAA;
        Din1 = 8'h00; Din2 = 8'h01; Din3 = 8'h02; Din4 = 8'h03;
        Din5 = 8'h04; Din6 = 8'h05; Din7 = 8'h06;

        #1;


        check_outputs(8'h7F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs match Din0", test_num);
        Din0 = 8'hFF;
        Din1 = 8'hFF; Din2 = 8'hFF; Din3 = 8'hFF; Din4 = 8'hFF;
        Din5 = 8'hFF; Din6 = 8'hFF; Din7 = 8'hFF;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Only Din1 matches Din0", test_num);
        Din0 = 8'h12;
        Din1 = 8'h12;
        Din2 = 8'h00; Din3 = 8'h00; Din4 = 8'h00;
        Din5 = 8'h00; Din6 = 8'h00; Din7 = 8'h00;

        #1;


        check_outputs(8'h7E);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Only Din7 matches Din0", test_num);
        Din0 = 8'h55;
        Din1 = 8'h00; Din2 = 8'h00; Din3 = 8'h00;
        Din4 = 8'h00; Din5 = 8'h00; Din6 = 8'h00;
        Din7 = 8'h55;

        #1;


        check_outputs(8'h3F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern match (Odd indices match)", test_num);
        Din0 = 8'hCC;
        Din1 = 8'hCC;
        Din2 = 8'h00;
        Din3 = 8'hCC;
        Din4 = 8'h00;
        Din5 = 8'hCC;
        Din6 = 8'h00;
        Din7 = 8'hCC;

        #1;


        check_outputs(8'h2A);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern match (Even indices match)", test_num);
        Din0 = 8'h33;
        Din1 = 8'h00;
        Din2 = 8'h33;
        Din3 = 8'h00;
        Din4 = 8'h33;
        Din5 = 8'h00;
        Din6 = 8'h33;
        Din7 = 8'h00;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Din0 is zero", test_num);
        Din0 = 8'h00;
        Din1 = 8'h00; Din2 = 8'h00; Din3 = 8'h11;
        Din4 = 8'h11; Din5 = 8'h00; Din6 = 8'h00; Din7 = 8'h11;


        #1;



        check_outputs(8'h4C);
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
        input [7:0] expected_Flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Flag === (expected_Flag ^ Flag ^ expected_Flag)) begin
                $display("PASS");
                $display("  Outputs: Flag=%h",
                         Flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Flag=%h",
                         expected_Flag);
                $display("  Got:      Flag=%h",
                         Flag);
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
