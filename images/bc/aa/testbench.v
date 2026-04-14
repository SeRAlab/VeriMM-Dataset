`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg chave1;
    reg chave2;
    wire s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .chave1(chave1),
        .chave2(chave2),
        .s(s)
    );
    task testcase001;

    begin
        test_num = 1; {chave1, chave2, a, b} = 4'b0000; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2; {chave1, chave2, a, b} = 4'b0001; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3; {chave1, chave2, a, b} = 4'b0010; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4; {chave1, chave2, a, b} = 4'b0011; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5; {chave1, chave2, a, b} = 4'b0100; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6; {chave1, chave2, a, b} = 4'b0101; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7; {chave1, chave2, a, b} = 4'b0110; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8; {chave1, chave2, a, b} = 4'b0111; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9; {chave1, chave2, a, b} = 4'b1000; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10; {chave1, chave2, a, b} = 4'b1001; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11; {chave1, chave2, a, b} = 4'b1010; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12; {chave1, chave2, a, b} = 4'b1011; #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13; {chave1, chave2, a, b} = 4'b1100; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14; {chave1, chave2, a, b} = 4'b1101; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15; {chave1, chave2, a, b} = 4'b1110; #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16; {chave1, chave2, a, b} = 4'b1111; #1;
 check_outputs(1'b1);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%b",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%b",
                         expected_s);
                $display("  Got:      s=%b",
                         s);
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
