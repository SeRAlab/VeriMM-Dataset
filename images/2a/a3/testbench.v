`timescale 1ns/1ps

module nat_translate_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] private_ip;
    wire [4:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_translate dut (
        .private_ip(private_ip),
        .public_ip(public_ip)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid Mapping - Private IP 5'h01", test_num);
        private_ip = 5'h01;

        #1;


        check_outputs(5'h10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid Mapping - Private IP 5'h02", test_num);
        private_ip = 5'h02;

        #1;


        check_outputs(5'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid Mapping - Private IP 5'h03", test_num);
        private_ip = 5'h03;

        #1;


        check_outputs(5'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid Mapping - Private IP 5'h00 (Expect Default)", test_num);
        private_ip = 5'h00;

        #1;


        check_outputs(5'h1F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid Mapping - Private IP 5'h1A (Expect Default)", test_num);
        private_ip = 5'h1A;

        #1;


        check_outputs(5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Invalid Mapping - Private IP 5'h1F (Expect Default)", test_num);
        private_ip = 5'h1F;

        #1;


        check_outputs(5'h1F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Valid Mapping - Private IP 5'h04", test_num);
        private_ip = 5'h04;

        #1;


        check_outputs(5'h13);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_translate Testbench");
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
        input [4:0] expected_public_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_public_ip === (expected_public_ip ^ public_ip ^ expected_public_ip)) begin
                $display("PASS");
                $display("  Outputs: public_ip=%h",
                         public_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: public_ip=%h",
                         expected_public_ip);
                $display("  Got:      public_ip=%h",
                         public_ip);
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
