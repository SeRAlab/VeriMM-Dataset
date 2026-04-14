`timescale 1ns/1ps

module fifo_64x16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_enable;
    reg reset;
    reg [15:0] write_data;
    reg write_enable;
    wire empty;
    wire full;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo_64x16 dut (
        .clk(clk),
        .read_enable(read_enable),
        .reset(reset),
        .write_data(write_data),
        .write_enable(write_enable),
        .empty(empty),
        .full(full),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            read_enable = 0;
            write_enable = 0;
            write_data = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset State");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, read_data);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Read");
            test_num = 2;
            reset_dut();


            write_enable = 1;
            write_data = 16'hAAAA;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1;
            read_enable = 0;


            #1;



            check_outputs(1'b1, 1'b0, 16'hAAAA);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill to Full Flag");
            test_num = 3;
            reset_dut();


            write_enable = 1;
            for (i = 0; i < 64; i = i + 1) begin
                write_data = i[15:0];
                @(posedge clk);
                #1;
            end
            write_enable = 0;





            #1;






            check_outputs(1'b0, 1'b1, read_data);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Empty from Full");
            test_num = 4;
            reset_dut();


            write_enable = 1;
            for (i = 0; i < 64; i = i + 1) begin
                write_data = i[15:0] + 16'h1000;
                @(posedge clk);
                #1;
            end
            write_enable = 0;


            read_enable = 1;
            for (i = 0; i < 63; i = i + 1) begin
                @(posedge clk);
                #1;
            end

            @(posedge clk);
            #1;
            read_enable = 0;


            #1;



            check_outputs(1'b1, 1'b0, (16'd63 + 16'h1000));
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Simultaneous Read and Write");
            test_num = 5;
            reset_dut();


            write_enable = 1;
            write_data = 16'h1111;
            @(posedge clk);
            #1;



            write_data = 16'h2222;
            read_enable = 1;
            @(posedge clk);
            #1;

            write_enable = 0;
            read_enable = 0;


            #1;



            check_outputs(1'b0, 1'b0, 16'h1111);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Overflow Condition");
            test_num = 6;
            reset_dut();


            write_enable = 1;
            for (i = 0; i < 64; i = i + 1) begin
                write_data = i[15:0];
                @(posedge clk);
                #1;
            end


            write_data = 16'hDEAD;
            @(posedge clk);
            #1;
            write_enable = 0;


            read_enable = 1;
            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk);
                #1;
            end
            read_enable = 0;


            #1;



            check_outputs(1'b1, 1'b0, 16'd63);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Underflow Condition");
            test_num = 7;
            reset_dut();


            read_enable = 1;
            @(posedge clk);
            #1;
            read_enable = 0;


            #1;



            check_outputs(1'b1, 1'b0, read_data);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo_64x16 Testbench");
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
        input expected_empty;
        input expected_full;
        input [15:0] expected_read_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, read_data=%h",
                         empty, full, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, read_data=%h",
                         expected_empty, expected_full, expected_read_data);
                $display("  Got:      empty=%b, full=%b, read_data=%h",
                         empty, full, read_data);
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
        $dumpvars(0,clk, read_enable, reset, write_data, write_enable, empty, full, read_data);
    end

endmodule
