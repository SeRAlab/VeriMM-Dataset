`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rst;
    wire [7:0] dout;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .din(din),
        .rst(rst),
        .dout(dout),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify downsampling (2nd sample)", test_num);
            reset_dut();


            din = 8'hA1;
            @(posedge clk);
            #1;


            din = 8'hB2;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'hB2, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify valid signal on odd samples (3rd sample)", test_num);
            reset_dut();


            din = 8'h01; @(posedge clk); #1;

            din = 8'h02; @(posedge clk); #1;

            din = 8'h03; @(posedge clk); #1;



            #1;




            check_outputs(dout, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify downsampling (4th sample)", test_num);
            reset_dut();

            din = 8'h11; @(posedge clk); #1;
            din = 8'h22; @(posedge clk); #1;
            din = 8'h33; @(posedge clk); #1;
            din = 8'h44; @(posedge clk); #1;


            #1;



            check_outputs(8'h44, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify with data patterns (0xAA, 0x55)", test_num);
            reset_dut();

            din = 8'hAA; @(posedge clk); #1;
            din = 8'h55; @(posedge clk); #1;

            #1;


            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify boundary values (0xFF)", test_num);
            reset_dut();

            din = 8'h00; @(posedge clk); #1;
            din = 8'hFF; @(posedge clk); #1;

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify reset logic mid-stream", test_num);
            reset_dut();


            din = 8'h01; @(posedge clk); #1;


            reset_dut();


            din = 8'hCC; @(posedge clk); #1;

            din = 8'hDD; @(posedge clk); #1;


            #1;



            check_outputs(8'hDD, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [7:0] expected_dout;
        input expected_valid;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, valid=%b",
                         dout, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, valid=%b",
                         expected_dout, expected_valid);
                $display("  Got:      dout=%h, valid=%b",
                         dout, valid);
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
        $dumpvars(0,clk, din, rst, dout, valid);
    end

endmodule
