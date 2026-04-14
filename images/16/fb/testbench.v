`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .data_in(data_in),
        .crc_out(crc_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=00", test_num);
        data_in = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=01 (x^0 bit)", test_num);
        data_in = 8'h01;
        #1;

        check_outputs(8'h91);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=02 (x^1 bit)", test_num);
        data_in = 8'h02;
        #1;

        check_outputs(8'hB3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=04 (x^2 bit)", test_num);
        data_in = 8'h04;
        #1;

        check_outputs(8'hF7);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=08 (x^3 bit)", test_num);
        data_in = 8'h08;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=10 (x^4 bit)", test_num);
        data_in = 8'h10;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=20 (x^5 bit)", test_num);
        data_in = 8'h20;
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=40 (x^6 bit)", test_num);
        data_in = 8'h40;
        #1;

        check_outputs(8'hDA);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=80 (x^7 bit)", test_num);
        data_in = 8'h80;
        #1;

        check_outputs(8'h25);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=FF (All bits set)", test_num);
        data_in = 8'hFF;
        #1;

        check_outputs(8'hC6);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=55 (Alternating bits 1)", test_num);
        data_in = 8'h55;
        #1;

        check_outputs(8'h42);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=AA (Alternating bits 2)", test_num);
        data_in = 8'hAA;
        #1;

        check_outputs(8'h84);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=12 (Specific test 1)", test_num);
        data_in = 8'h12;
        #1;

        check_outputs(8'h4D);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Data=34 (Specific test 2)", test_num);
        data_in = 8'h34;
        #1;

        check_outputs(8'h64);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [7:0] expected_crc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
