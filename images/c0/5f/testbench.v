`timescale 1ns/1ps

module fifo4_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    reg [7:0] din;
    reg re;
    reg rst;
    reg we;
    wire [7:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo4 dut (
        .clk(clk),
        .clr(clr),
        .din(din),
        .re(re),
        .rst(rst),
        .we(we),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 0;
            clr = 0;
            we = 0;
            re = 0;
            din = 0;
            repeat(2) @(posedge clk);
            #1 rst = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write then Read", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; din = 8'hA5;
            @(negedge clk);
            we = 0;


            @(negedge clk);
            re = 1;
            @(posedge clk);
            #1 re = 0;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO to Full (4 elements)", test_num);
            reset_dut();

            @(negedge clk);
            we = 1; din = 8'h01; @(negedge clk);
            we = 1; din = 8'h02; @(negedge clk);
            we = 1; din = 8'h03; @(negedge clk);
            we = 1; din = 8'h04; @(negedge clk);
            we = 0;



            #1;




            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read all 4 elements from Full FIFO", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; din = 8'h11; @(negedge clk);
            we = 1; din = 8'h22; @(negedge clk);
            we = 1; din = 8'h33; @(negedge clk);
            we = 1; din = 8'h44; @(negedge clk);
            we = 0;


            re = 1;
            repeat(3) @(negedge clk);

            @(posedge clk);
            #1 re = 0;


            #1;



            check_outputs(8'h44, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Clear while half full", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; din = 8'hAA; @(negedge clk);
            we = 1; din = 8'hBB; @(negedge clk);
            we = 0;


            @(negedge clk);
            clr = 1;
            @(negedge clk);
            clr = 0;


            #1;



            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Overflow Protection (Write 5 items to depth 4)", test_num);
            reset_dut();

            @(negedge clk);
            we = 1;
            din = 8'h01; @(negedge clk);
            din = 8'h02; @(negedge clk);
            din = 8'h03; @(negedge clk);
            din = 8'h04; @(negedge clk);
            din = 8'h05; @(negedge clk);
            we = 0;


            #1;



            check_outputs(8'h01, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Pointer Wrapping (Read 2, Write 2)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; din = 8'h01; @(negedge clk);
            din = 8'h02; @(negedge clk);
            din = 8'h03; @(negedge clk);
            din = 8'h04; @(negedge clk);
            we = 0;


            re = 1; @(negedge clk);
            re = 1; @(negedge clk);
            re = 0;


            we = 1; din = 8'h05; @(negedge clk);
            din = 8'h06; @(negedge clk);
            we = 0;


            #1;



            check_outputs(8'h03, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; din = 8'h10;
            @(negedge clk);
            we = 0;


            @(negedge clk);
            re = 1; we = 1; din = 8'h20;
            @(negedge clk);
            re = 0; we = 0;


            #1;



            check_outputs(8'h20, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo4 Testbench");
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
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,clk, clr, din, re, rst, we, dout, empty, full);
    end

endmodule
