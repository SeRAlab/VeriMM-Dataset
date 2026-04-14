`timescale 1ns/1ps

module nat_translation_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] private_ip;
    reg [31:0] public_ip;
    wire [31:0] translated_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_translation dut (
        .private_ip(private_ip),
        .public_ip(public_ip),
        .translated_ip(translated_ip)
    );
    task testcase001;

        begin
            test_num = 1;
            private_ip = 32'hC0A80101;
            public_ip  = 32'hCB007105;
            $display("Test %0d: Class C Private IP Translation", test_num);
            #1;

            check_outputs(32'hCB007105);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            private_ip = 32'h0A000001;
            public_ip  = 32'hCB007105;
            $display("Test %0d: Class A Private IP Translation", test_num);
            #1;

            check_outputs(32'hCB007105);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            private_ip = 32'hAC100001;
            public_ip  = 32'hCB007105;
            $display("Test %0d: Class B Private IP Translation", test_num);
            #1;

            check_outputs(32'hCB007105);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            private_ip = 32'h08080808;
            public_ip  = 32'hCB007105;
            $display("Test %0d: Public IP Input (Pass-through)", test_num);
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            private_ip = 32'hC0A8FFFF;
            public_ip  = 32'h4D556677;
            $display("Test %0d: Boundary Class C Private IP", test_num);
            #1;

            check_outputs(32'h4D556677);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_translation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
