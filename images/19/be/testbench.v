`timescale 1ns/1ps

module mux32to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in;
    reg [4:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux32to1 dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 32'hFFFFFFFE;
            sel = 5'd0;
            $display("Test %0d: Select bit 0 (Value 0)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 32'h00000001;
            sel = 5'd0;
            $display("Test %0d: Select bit 0 (Value 1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 32'h7FFFFFFF;
            sel = 5'd31;
            $display("Test %0d: Select bit 31 (Value 0)", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 32'h80000000;
            sel = 5'd31;
            $display("Test %0d: Select bit 31 (Value 1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 32'h00008000;
            sel = 5'd15;
            $display("Test %0d: Select bit 15 (Value 1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 32'hFFFF7FFF;
            sel = 5'd16;
            $display("Test %0d: Select bit 16 (Value 1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 32'hAAAAAAAA;
            sel = 5'd1;
            $display("Test %0d: Checkerboard A, Select bit 1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 32'hAAAAAAAA;
            sel = 5'd0;
            $display("Test %0d: Checkerboard A, Select bit 0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 32'h55555555;
            sel = 5'd0;
            $display("Test %0d: Checkerboard 5, Select bit 0", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        integer i;
        begin
            test_num = 10;
            $display("Test %0d: Walking Bit Test", test_num);
            for (i = 0; i < 32; i = i + 1) begin
                in = (1 << i);
                sel = i[4:0];
                #1;
                if (out !== 1'b1) begin
                    $display("  Walking bit failure at index %0d", i);
                    fail_count = fail_count + 1;
                end
            end

            if (fail_count == 0) pass_count = pass_count + 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux32to1 Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
