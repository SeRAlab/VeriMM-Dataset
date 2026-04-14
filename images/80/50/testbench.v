`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] addr;
    reg we;
    wire rd;
    wire wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .we(we),
        .rd(rd),
        .wr(wr)
    );
    task testcase001;

    begin
        test_num = 1;
        addr = 8'h05;
        we = 1'b1;
        $display("Testcase %0d: Write to unprotected address 0x05 (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        addr = 8'h20;
        we = 1'b0;
        $display("Testcase %0d: Read from unprotected address 0x20 (we=0)", test_num);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        addr = 8'h30;
        we = 1'b1;
        $display("Testcase %0d: Attempt write to protected address 0x30 (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        addr = 8'h38;
        we = 1'b1;
        $display("Testcase %0d: Attempt write to protected address 0x38 (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        addr = 8'h3F;
        we = 1'b1;
        $display("Testcase %0d: Attempt write to protected address 0x3F (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        addr = 8'hA0;
        we = 1'b1;
        $display("Testcase %0d: Attempt write to protected address 0xA0 (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        addr = 8'hA7;
        we = 1'b1;
        $display("Testcase %0d: Attempt write to protected address 0xA7 (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        addr = 8'hAF;
        we = 1'b1;
        $display("Testcase %0d: Attempt write to protected address 0xAF (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        addr = 8'h2F;
        we = 1'b1;
        $display("Testcase %0d: Write to address just below range 1: 0x2F (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        addr = 8'h40;
        we = 1'b1;
        $display("Testcase %0d: Write to address just above range 1: 0x40 (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        addr = 8'h9F;
        we = 1'b1;
        $display("Testcase %0d: Write to address just below range 2: 0x9F (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        addr = 8'hB0;
        we = 1'b1;
        $display("Testcase %0d: Write to address just above range 2: 0xB0 (we=1)", test_num);

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        addr = 8'hA5;
        we = 1'b0;
        $display("Testcase %0d: Read from protected address 0xA5 (we=0)", test_num);

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
        input expected_rd;
        input expected_wr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rd === (expected_rd ^ rd ^ expected_rd) &&
                expected_wr === (expected_wr ^ wr ^ expected_wr)) begin
                $display("PASS");
                $display("  Outputs: rd=%b, wr=%b",
                         rd, wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%b, wr=%b",
                         expected_rd, expected_wr);
                $display("  Got:      rd=%b, wr=%b",
                         rd, wr);
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
