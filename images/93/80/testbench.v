`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] hx;
    wire [7:0] asciiHex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hx(hx),
        .asciiHex(asciiHex)
    );
    task testcase001;

    begin
        test_num = 1;
        hx = 4'h0;
        #1;

        check_outputs(8'h30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        hx = 4'h1;
        #1;

        check_outputs(8'h31);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        hx = 4'h2;
        #1;

        check_outputs(8'h32);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        hx = 4'h3;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        hx = 4'h4;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        hx = 4'h5;
        #1;

        check_outputs(8'h35);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        hx = 4'h6;
        #1;

        check_outputs(8'h36);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        hx = 4'h7;
        #1;

        check_outputs(8'h37);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        hx = 4'h8;
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        hx = 4'h9;
        #1;

        check_outputs(8'h39);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        hx = 4'hA;
        #1;

        check_outputs(8'h61);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        hx = 4'hB;
        #1;

        check_outputs(8'h62);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        hx = 4'hC;
        #1;

        check_outputs(8'h63);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        hx = 4'hD;
        #1;

        check_outputs(8'h64);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        hx = 4'hE;
        #1;

        check_outputs(8'h65);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        hx = 4'hF;
        #1;

        check_outputs(8'h66);
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
        input [7:0] expected_asciiHex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_asciiHex === (expected_asciiHex ^ asciiHex ^ expected_asciiHex)) begin
                $display("PASS");
                $display("  Outputs: asciiHex=%h",
                         asciiHex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: asciiHex=%h",
                         expected_asciiHex);
                $display("  Got:      asciiHex=%h",
                         asciiHex);
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
