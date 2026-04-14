`timescale 1ns/1ps

module fifo_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] data_in;
    reg read_enb;
    reg resetn;
    reg write_enb;
    wire [7:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo dut (
        .clock(clock),
        .data_in(data_in),
        .read_enb(read_enb),
        .resetn(resetn),
        .write_enb(write_enb),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 1'b0;
            write_enb = 1'b0;
            read_enb = 1'b0;
            data_in = 8'h00;
            @(posedge clock);
            #2 resetn = 1'b1;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State", test_num);
            reset_dut();

            #1 #1;
 check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Write", test_num);
            reset_dut();

            @(posedge clock);
            write_enb = 1'b1;
            data_in = 8'hA5;
            @(posedge clock);
            write_enb = 1'b0;


            #1 #1;
 check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write until Full", test_num);
            reset_dut();

            @(posedge clock);
            write_enb = 1'b1;

            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 1;
                @(posedge clock);
            end
            write_enb = 1'b0;


            #1 #1;
 check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Read Data Verification", test_num);
            reset_dut();


            @(posedge clock);
            write_enb = 1'b1;
            data_in = 8'h55;
            @(posedge clock);
            write_enb = 1'b0;


            @(posedge clock);
            read_enb = 1'b1;
            @(posedge clock);
            read_enb = 1'b0;


            #1 #1;
 check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill then Empty", test_num);
            reset_dut();


            write_enb = 1'b1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 8'h10;
                @(posedge clock);
            end
            write_enb = 1'b0;


            read_enb = 1'b1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clock);
            end
            read_enb = 1'b0;


            #1 #1;
 check_outputs(8'h17, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Check", test_num);
            reset_dut();

            write_enb = 1'b1;

            for (i = 0; i < 10; i = i + 1) begin
                data_in = i;
                @(posedge clock);
            end
            write_enb = 1'b0;


            #1 #1;
 check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Underflow Check", test_num);
            reset_dut();


            @(posedge clock);
            read_enb = 1'b1;
            repeat(3) @(posedge clock);
            read_enb = 1'b0;


            #1 #1;
 check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();


            write_enb = 1'b1;
            data_in = 8'h33;
            @(posedge clock);



            data_in = 8'h44;
            read_enb = 1'b1;
            @(posedge clock);

            write_enb = 1'b0;
            read_enb = 1'b0;


            #1 #1;
 check_outputs(8'h33, 1'b0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation", test_num);
            reset_dut();


            write_enb = 1'b1;
            data_in = 8'hAA; @(posedge clock);
            data_in = 8'hBB; @(posedge clock);
            write_enb = 1'b0;


            #3 resetn = 1'b0;
            #10 resetn = 1'b1;
            @(posedge clock);


            #1 #1;
 check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clock, data_in, read_enb, resetn, write_enb, data_out, empty, full);
    end

endmodule
