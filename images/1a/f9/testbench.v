`timescale 1ns/1ps

module divider_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] denominator;
    reg [7:0] numerator;
    reg start;
    wire done;
    wire [7:0] quotient;
    wire [7:0] remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider dut (
        .clk(clk),
        .denominator(denominator),
        .numerator(numerator),
        .start(start),
        .done(done),
        .quotient(quotient),
        .remainder(remainder)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            denominator = 8'h0;
            numerator = 8'h0;
            start = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task wait_for_done;

        begin
            @(posedge clk);
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;


            fork : wait_proc
                begin
                    wait(done == 1'b1);
                    disable wait_proc;
                end
                begin
                    repeat (100) @(posedge clk);
                    $display("Error: Timeout waiting for done signal");
                    disable wait_proc;
                end
            join

            #2;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: 100 / 10", test_num);
            numerator = 8'd100;
            denominator = 8'd10;
            wait_for_done();
            #1;

            check_outputs(1'b1, 8'd10, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %03d: 25 / 4", test_num);
            numerator = 8'd25;
            denominator = 8'd4;
            wait_for_done();
            #1;

            check_outputs(1'b1, 8'd6, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %03d: 5 / 12", test_num);
            numerator = 8'd5;
            denominator = 8'd12;
            wait_for_done();
            #1;

            check_outputs(1'b1, 8'd0, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %03d: 50 / 1", test_num);
            numerator = 8'd50;
            denominator = 8'd1;
            wait_for_done();
            #1;

            check_outputs(1'b1, 8'd50, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %03d: 123 / 123", test_num);
            numerator = 8'd123;
            denominator = 8'd123;
            wait_for_done();
            #1;

            check_outputs(1'b1, 8'd1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %03d: Division by Zero (80 / 0)", test_num);
            numerator = 8'd80;
            denominator = 8'd0;
            wait_for_done();


            #1;



            check_outputs(1'b1, 8'hFF, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %03d: Max Numerator (255 / 2)", test_num);
            numerator = 8'd255;
            denominator = 8'd2;
            wait_for_done();
            #1;

            check_outputs(1'b1, 8'd127, 8'd1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Testcase %03d: Zero Numerator (0 / 45)", test_num);
            numerator = 8'd0;
            denominator = 8'd45;
            wait_for_done();
            #1;

            check_outputs(1'b1, 8'd0, 8'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_done;
        input [7:0] expected_quotient;
        input [7:0] expected_remainder;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_quotient === (expected_quotient ^ quotient ^ expected_quotient) &&
                expected_remainder === (expected_remainder ^ remainder ^ expected_remainder)) begin
                $display("PASS");
                $display("  Outputs: done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, quotient=%h, remainder=%h",
                         expected_done, expected_quotient, expected_remainder);
                $display("  Got:      done=%b, quotient=%h, remainder=%h",
                         done, quotient, remainder);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, denominator, numerator, start, done, quotient, remainder);
    end

endmodule
