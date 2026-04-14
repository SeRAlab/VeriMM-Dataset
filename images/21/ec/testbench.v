`timescale 1ns/1ps

module decoder5to32_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    wire [31:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder5to32 dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 5'd0;
            #10;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 5'd31;
            #10;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 5'd1;
            #10;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 5'd4;
            #10;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 5'd8;
            #10;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 5'd16;
            #10;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 5'd15;
            #10;
            #1;

            check_outputs(32'h00008000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 5'd10;
            #10;
            #1;

            check_outputs(32'h00000400);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 5'd21;
            #10;
            #1;

            check_outputs(32'h00200000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 5'd30;
            #10;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase011;

        integer i;
        begin
            $display("Starting Exhaustive Check...");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = 11 + i;
                A = i;
                #10;
                #1;

                check_outputs(32'b1 << i);
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
        $display("decoder5to32 Testbench");
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
        input [31:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
