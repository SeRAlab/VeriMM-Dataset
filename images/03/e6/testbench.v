`timescale 1ns/1ps

module nat_logic_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] external_ip;
    reg [31:0] internal_ip;
    reg nat_type;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_logic dut (
        .external_ip(external_ip),
        .internal_ip(internal_ip),
        .nat_type(nat_type),
        .translated_ip(translated_ip)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Static NAT - Standard Mapping", test_num);
        internal_ip = 32'hC0A8010A;
        external_ip = 32'h08080808;
        nat_type = 1'b0;
        #10;
        #1;

        check_outputs(32'h08080808);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Dynamic NAT - Standard Mapping", test_num);
        internal_ip = 32'h0A000005;
        external_ip = 32'hD83AD38E;
        nat_type = 1'b1;
        #10;
        #1;

        check_outputs(32'hD83AD38E);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NAT with All-Zero External IP", test_num);
        internal_ip = 32'hC0A80001;
        external_ip = 32'h00000000;
        nat_type = 1'b0;
        #10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NAT with All-Ones External IP", test_num);
        internal_ip = 32'hC0A80001;
        external_ip = 32'hFFFFFFFF;
        nat_type = 1'b1;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Rapid NAT Type Switching", test_num);
        internal_ip = 32'hAC100001;
        external_ip = 32'h42424242;


        nat_type = 1'b0;
        #5;

        nat_type = 1'b1;
        #5;

        #1;


        check_outputs(32'h42424242);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Variation of Internal Source IP", test_num);
        internal_ip = 32'hC0A801FE;
        external_ip = 32'h01020304;
        nat_type = 1'b0;
        #10;
        internal_ip = 32'hC0A801FF;
        #10;
        #1;

        check_outputs(32'h01020304);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_logic Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
