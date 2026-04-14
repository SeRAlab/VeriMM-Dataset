`timescale 1ns/1ps

module nat_device_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [31:0] private_ip;
    reg [31:0] public_ip;
    wire [31:0] output_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nat_device dut (
        .control(control),
        .private_ip(private_ip),
        .public_ip(public_ip),
        .output_ip(output_ip)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control=0, Expect output_ip = private_ip", test_num);
            private_ip = 32'hC0A80001;
            public_ip  = 32'h08080808;
            control = 1'b0;
            #1;

            check_outputs(32'hC0A80001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Control=1, Expect output_ip = public_ip", test_num);
            private_ip = 32'hC0A80001;
            public_ip  = 32'h08080808;
            control = 1'b1;
            #1;

            check_outputs(32'h08080808);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values (All 1s), Control=0", test_num);
            private_ip = 32'hFFFFFFFF;
            public_ip  = 32'h00000000;
            control = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary values (All 0s), Control=1", test_num);
            private_ip = 32'hFFFFFFFF;
            public_ip  = 32'h00000000;
            control = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switching control with pattern data", test_num);
            private_ip = 32'hAAAAAAAA;
            public_ip  = 32'h55555555;
            control = 1'b0;
            #5;
            control = 1'b1;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary IP mapping check", test_num);
            private_ip = 32'h0A00000F;
            public_ip  = 32'hAC100001;
            control = 1'b1;
            #1;

            check_outputs(32'hAC100001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nat_device Testbench");
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
        input [31:0] expected_output_ip;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_ip === (expected_output_ip ^ output_ip ^ expected_output_ip)) begin
                $display("PASS");
                $display("  Outputs: output_ip=%h",
                         output_ip);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_ip=%h",
                         expected_output_ip);
                $display("  Got:      output_ip=%h",
                         output_ip);
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
