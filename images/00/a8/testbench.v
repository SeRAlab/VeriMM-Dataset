`timescale 1ns/1ps

module NAT_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] internal_ip;
    reg translate;
    wire [4:0] public_ip;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    NAT dut (
        .internal_ip(internal_ip),
        .translate(translate),
        .public_ip(public_ip)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Translate 00000 with translate=1", test_num);
            internal_ip = 5'b00000;
            translate = 1'b1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Translate 00001 with translate=1", test_num);
            internal_ip = 5'b00001;
            translate = 1'b1;
            #1;

            check_outputs(5'b11110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Translate 00010 with translate=1", test_num);
            internal_ip = 5'b00010;
            translate = 1'b1;
            #1;

            check_outputs(5'b11101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Translate 00011 with translate=1", test_num);
            internal_ip = 5'b00011;
            translate = 1'b1;
            #1;

            check_outputs(5'b11100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Translate 00100 with translate=1", test_num);
            internal_ip = 5'b00100;
            translate = 1'b1;
            #1;

            check_outputs(5'b11011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Unmapped Internal IP (00101) with translate=1", test_num);
            internal_ip = 5'b00101;
            translate = 1'b1;
            #1;

            check_outputs(5'b00101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Internal IP (00000) with translate=0", test_num);
            internal_ip = 5'b00000;
            translate = 1'b0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Internal IP (00011) with translate=0", test_num);
            internal_ip = 5'b00011;
            translate = 1'b0;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: High-range Unmapped IP (11111) with translate=1", test_num);
            internal_ip = 5'b11111;
            translate = 1'b1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Mid-range IP (10101) with translate=0", test_num);
            internal_ip = 5'b10101;
            translate = 1'b0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("NAT Testbench");
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
