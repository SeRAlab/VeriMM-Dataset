`timescale 1ns/1ps

module priority_encoder_32to5_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_32to5 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits zero (Special Case)", test_num);
            in = 32'h0000_0000;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only bit 0 set", test_num);
            in = 32'h0000_0001;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only bit 31 set", test_num);
            in = 32'h8000_0000;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple bits set (bit 4, 2, 0) - Priority Check", test_num);
            in = 32'h0000_0015;
            #1;

            check_outputs(5'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple bits set (bit 15, 14, 13) - Priority Check", test_num);
            in = 32'h0000_E000;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits set - Priority Check", test_num);
            in = 32'hFFFF_FFFF;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range single bit (bit 16)", test_num);
            in = 32'h0001_0000;
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower-range multiple bits (bit 7 and bit 6)", test_num);
            in = 32'h0000_00C0;
            #1;

            check_outputs(5'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-range priority (bit 29 set with others)", test_num);
            in = 32'h2000_FFFF;
            #1;

            check_outputs(5'd29);
        end
        endtask

    task testcase010;

        integer i;
        begin
            $display("Starting Exhaustive Walking 1s Test...");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                in = (32'h1 << i);
                #1;

                check_outputs(i[4:0]);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_32to5 Testbench");
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
        input [4:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
