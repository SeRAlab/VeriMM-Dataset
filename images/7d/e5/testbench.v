`timescale 1ns/1ps

module register_file_8bit_4reg_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [1:0] read_addr;
    reg we;
    reg [1:0] write_addr;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file_8bit_4reg dut (
        .clk(clk),
        .data_in(data_in),
        .read_addr(read_addr),
        .we(we),
        .write_addr(write_addr),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            $display("Resetting DUT...");
            we = 0;
            write_addr = 0;
            read_addr = 0;
            data_in = 0;
            @(posedge clk);

            for (i = 0; i < 4; i = i + 1) begin
                we = 1;
                write_addr = i;
                data_in = 8'h00;
                @(posedge clk);
            end
            we = 0;
            data_in = 0;
            write_addr = 0;
            read_addr = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read - Register 0", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            write_addr = 2'b00;
            data_in = 8'hAA;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b00;
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read - Register 1", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            write_addr = 2'b01;
            data_in = 8'h55;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b01;
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Basic Write and Read - Register 2", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            write_addr = 2'b10;
            data_in = 8'hF0;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b10;
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Basic Write and Read - Register 3", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            write_addr = 2'b11;
            data_in = 8'h0F;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b11;
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Write Enable (WE) Low Check", test_num);
            reset_dut();
            @(negedge clk);
            we = 0;
            write_addr = 2'b00;
            data_in = 8'hFF;
            @(posedge clk);
            #1;
            read_addr = 2'b00;
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Overwriting a Register", test_num);
            reset_dut();
            @(negedge clk);

            we = 1;
            write_addr = 2'b10;
            data_in = 8'h11;
            @(posedge clk);

            @(negedge clk);
            data_in = 8'h22;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b10;
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Reading from a different address than writing", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            write_addr = 2'b01;
            data_in = 8'hCC;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 2'b00;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file_8bit_4reg Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, read_addr, we, write_addr, data_out);
    end

endmodule
