`timescale 1ns/1ps

module MUX4_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg [1:0] sel;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MUX4 dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 4'b0000;
            sel = 2'b00;
            $display("Testcase %0d: sel=00, in=0000. Expecting in[0]=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 4'b0001;
            sel = 2'b00;
            $display("Testcase %0d: sel=00, in=0001. Expecting in[0]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 4'b0000;
            sel = 2'b01;
            $display("Testcase %0d: sel=01, in=0000. Expecting in[1]=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 4'b0010;
            sel = 2'b01;
            $display("Testcase %0d: sel=01, in=0010. Expecting in[1]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 4'b0000;
            sel = 2'b10;
            $display("Testcase %0d: sel=10, in=0000. Expecting in[2]=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 4'b0100;
            sel = 2'b10;
            $display("Testcase %0d: sel=10, in=0100. Expecting in[2]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 4'b0000;
            sel = 2'b11;
            $display("Testcase %0d: sel=11, in=0000. Expecting in[3]=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 4'b1000;
            sel = 2'b11;
            $display("Testcase %0d: sel=11, in=1000. Expecting in[3]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 4'b1010;
            sel = 2'b00;
            #5;
            $display("Testcase %0d: sel=00, in=1010. Expecting in[0]=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 4'b1010;
            sel = 2'b01;
            #5;
            $display("Testcase %0d: sel=01, in=1010. Expecting in[1]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            in = 4'b1010;
            sel = 2'b10;
            #5;
            $display("Testcase %0d: sel=10, in=1010. Expecting in[2]=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            in = 4'b1010;
            sel = 2'b11;
            #5;
            $display("Testcase %0d: sel=11, in=1010. Expecting in[3]=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MUX4 Testbench");
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
        testcase012();
        
        
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
