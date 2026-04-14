`timescale 1ns/1ps

module LinkedListTraversal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] head;
    reg reset;
    wire [7:0] current_value;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinkedListTraversal dut (
        .clk(clk),
        .head(head),
        .reset(reset),
        .current_value(current_value),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            head = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Empty List", test_num);
            reset_dut();

            head = 8'h00;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Single Node List", test_num);


            dut.mem[8'h10] = 8'hAA;
            dut.mem[8'h11] = 8'h00;

            reset_dut();
            head = 8'h10;


            while (!done) @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Multi-Node List", test_num);


            dut.mem[8'h20] = 8'h11;
            dut.mem[8'h21] = 8'h30;

            dut.mem[8'h30] = 8'h22;
            dut.mem[8'h31] = 8'h40;

            dut.mem[8'h40] = 8'h33;
            dut.mem[8'h41] = 8'h00;

            reset_dut();
            head = 8'h20;



            while (!done) @(posedge clk);
            @(posedge clk);


            #1;



            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase%03d: Scattered Nodes", test_num);


            dut.mem[8'hFE] = 8'hDE;
            dut.mem[8'hFF] = 8'h02;

            dut.mem[8'h02] = 8'hAD;
            dut.mem[8'h03] = 8'h80;

            dut.mem[8'h80] = 8'hBE;
            dut.mem[8'h81] = 8'h00;

            reset_dut();
            head = 8'hFE;

            while (!done) @(posedge clk);
            @(posedge clk);

            #1;


            check_outputs(8'hBE, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinkedListTraversal Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_current_value;
        input expected_done;
        begin
            if (expected_current_value === (expected_current_value ^ current_value ^ expected_current_value) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: current_value=%h, done=%b",
                         current_value, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_value=%h, done=%b",
                         expected_current_value, expected_done);
                $display("  Got:      current_value=%h, done=%b",
                         current_value, done);
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
        $dumpvars(0,clk, head, reset, current_value, done);
    end

endmodule
