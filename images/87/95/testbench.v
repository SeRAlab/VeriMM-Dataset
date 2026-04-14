`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg alt_mosi;
    reg alt_nss;
    reg alt_sck;
    reg main_mosi;
    reg main_nss;
    reg main_sck;
    reg miso;
    wire alt_miso;
    wire main_miso;
    wire mosi;
    wire nss;
    wire sck;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alt_mosi(alt_mosi),
        .alt_nss(alt_nss),
        .alt_sck(alt_sck),
        .main_mosi(main_mosi),
        .main_nss(main_nss),
        .main_sck(main_sck),
        .miso(miso),
        .alt_miso(alt_miso),
        .main_miso(main_miso),
        .mosi(mosi),
        .nss(nss),
        .sck(sck)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All buses inactive (Idle state)", test_num);
        main_nss = 1'b1; main_sck = 1'b0; main_mosi = 1'b0;
        alt_nss = 1'b1;  alt_sck = 1'b0;  alt_mosi = 1'b0;
        miso = 1'b0;
        #10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Main bus active, logic high data", test_num);
        main_nss = 1'b0; main_sck = 1'b1; main_mosi = 1'b1;
        alt_nss = 1'b1;  alt_sck = 1'b0;  alt_mosi = 1'b0;
        miso = 1'b1;
        #10;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Main bus active, logic low data", test_num);
        main_nss = 1'b0; main_sck = 1'b0; main_mosi = 1'b0;
        alt_nss = 1'b1;  alt_sck = 1'b1;  alt_mosi = 1'b1;
        miso = 1'b0;
        #10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Alternate bus active, logic high data", test_num);
        main_nss = 1'b1; main_sck = 1'b0; main_mosi = 1'b0;
        alt_nss = 1'b0;  alt_sck = 1'b1;  alt_mosi = 1'b1;
        miso = 1'b1;
        #10;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternate bus active, logic low data", test_num);
        main_nss = 1'b1; main_sck = 1'b1; main_mosi = 1'b1;
        alt_nss = 1'b0;  alt_sck = 1'b0;  alt_mosi = 1'b0;
        miso = 1'b0;
        #10;

        #1;


        check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Conflict (Both active) - Priority Check", test_num);

        main_nss = 1'b0; main_sck = 1'b1; main_mosi = 1'b0;
        alt_nss = 1'b0;  alt_sck = 1'b0;  alt_mosi = 1'b1;
        miso = 1'b1;
        #10;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Main active - ignoring changes on Alt inputs", test_num);
        main_nss = 1'b0; main_sck = 1'b0; main_mosi = 1'b1;
        alt_nss = 1'b1;  alt_sck = 1'b1;  alt_mosi = 1'b0;
        miso = 1'b1;
        #5;
        alt_sck = 1'b0; alt_mosi = 1'b1;
        #5;

        #1;


        check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Alt active - ignoring changes on Main inputs", test_num);
        main_nss = 1'b1; main_sck = 1'b1; main_mosi = 1'b0;
        alt_nss = 1'b0;  alt_sck = 1'b1;  alt_mosi = 1'b1;
        miso = 1'b0;
        #5;
        main_sck = 1'b0; main_mosi = 1'b1;
        #5;

        #1;


        check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
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
        input expected_alt_miso;
        input expected_main_miso;
        input expected_mosi;
        input expected_nss;
        input expected_sck;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alt_miso === (expected_alt_miso ^ alt_miso ^ expected_alt_miso) &&
                expected_main_miso === (expected_main_miso ^ main_miso ^ expected_main_miso) &&
                expected_mosi === (expected_mosi ^ mosi ^ expected_mosi) &&
                expected_nss === (expected_nss ^ nss ^ expected_nss) &&
                expected_sck === (expected_sck ^ sck ^ expected_sck)) begin
                $display("PASS");
                $display("  Outputs: alt_miso=%b, main_miso=%b, mosi=%b, nss=%b, sck=%b",
                         alt_miso, main_miso, mosi, nss, sck);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alt_miso=%b, main_miso=%b, mosi=%b, nss=%b, sck=%b",
                         expected_alt_miso, expected_main_miso, expected_mosi, expected_nss, expected_sck);
                $display("  Got:      alt_miso=%b, main_miso=%b, mosi=%b, nss=%b, sck=%b",
                         alt_miso, main_miso, mosi, nss, sck);
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
