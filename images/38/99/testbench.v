`timescale 1ns/1ps

module nat_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg select;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat dut (
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .select(select),
        .translated_ip(translated_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Internal IP (Standard Private IP)", test_num);
            internal_ip = 32'hC0A8_010A;
            external_ip = 32'h0808_0808;
            select = 1'b1;
            #10;
            #1;

            check_outputs(32'hC0A8_010A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select External IP (Standard Public IP)", test_num);
            internal_ip = 32'hC0A8_010A;
            external_ip = 32'h0808_0808;
            select = 1'b0;
            #10;
            #1;

            check_outputs(32'h0808_0808);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Internal IP (All Zeros Boundary)", test_num);
            internal_ip = 32'h0000_0000;
            external_ip = 32'hFFFF_FFFF;
            select = 1'b1;
            #10;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select External IP (All Ones Boundary)", test_num);
            internal_ip = 32'h0000_0000;
            external_ip = 32'hFFFF_FFFF;
            select = 1'b0;
            #10;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternate Bit Pattern Internal", test_num);
            internal_ip = 32'h5555_5555;
            external_ip = 32'hAAAA_AAAA;
            select = 1'b1;
            #10;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternate Bit Pattern External", test_num);
            internal_ip = 32'h5555_5555;
            external_ip = 32'hAAAA_AAAA;
            select = 1'b0;
            #10;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Dynamic Switching Check", test_num);
            internal_ip = 32'hDEAF_BEEF;
            external_ip = 32'hBADC_0FFE;


            select = 1'b1;
            #5;

            select = 1'b0;
            #10;
            #1;

            check_outputs(32'hBADC_0FFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat Testbench");
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
        input [31:0] expected_translated_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_translated_ip === (expected_translated_ip ^ translated_ip ^ expected_translated_ip)) begin
                $display("PASS");
                $display("  Outputs: translated_ip=%h",
                         translated_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: translated_ip=%h",
                         expected_translated_ip);
                $display("  Got:      translated_ip=%h",
                         translated_ip);
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
