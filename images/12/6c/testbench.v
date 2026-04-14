`timescale 1ns/1ps

module fifo_queue_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg pop;
    reg push;
    reg rst;
    wire [3:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_queue dut (
        .clk(clk),
        .data_in(data_in),
        .pop(pop),
        .push(push),
        .rst(rst),
        .data_out(data_out),
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
            rst = 1;
            push = 0;
            pop = 0;
            data_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'bzzzz, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Push Check", test_num);
            reset_dut();

            data_in = 4'hA;
            push = 1;
            @(posedge clk);
            #1 push = 0;


            #1;



            check_outputs(4'hA, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO Check", test_num);
            reset_dut();


            push = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            #1 push = 0;


            #1;



            check_outputs(4'h1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full to Empty Transition", test_num);
            reset_dut();


            push = 1;
            data_in = 4'h5; @(posedge clk);
            data_in = 4'h6; @(posedge clk);
            data_in = 4'h7; @(posedge clk);
            data_in = 4'h8; @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Handling Check", test_num);
            reset_dut();

            push = 1;
            data_in = 4'h1; @(posedge clk);
            data_in = 4'h2; @(posedge clk);
            data_in = 4'h3; @(posedge clk);
            data_in = 4'h4; @(posedge clk);
            data_in = 4'hF; @(posedge clk);
            #1 push = 0;


            #1;



            check_outputs(4'h1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Handling Check", test_num);
            reset_dut();

            pop = 1;
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Push-Pop Sequence", test_num);
            reset_dut();


            push = 1;
            data_in = 4'hA; @(posedge clk);
            data_in = 4'hB; @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(4'hB, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_queue Testbench");
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
        input [3:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, pop, push, rst, data_out, empty, full);
    end

endmodule
