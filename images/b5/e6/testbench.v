`timescale 1ns/1ps

module simple_ram_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address;
    reg clk;
    reg [7:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_ram dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 16'h0;
            data_in = 8'h0;
            read_enable = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read at 0x0000", test_num);


            @(posedge clk);
            address = 16'h0000;
            data_in = 8'hAA;
            write_enable = 1;
            read_enable = 0;

            @(posedge clk);

            write_enable = 0;
            read_enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Boundary Address 0xFFFF", test_num);


            @(posedge clk);
            address = 16'hFFFF;
            data_in = 8'h55;
            write_enable = 1;

            @(posedge clk);

            write_enable = 0;
            read_enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwriting data", test_num);


            @(posedge clk);
            address = 16'h1234;
            data_in = 8'h11;
            write_enable = 1;


            @(posedge clk);
            data_in = 8'h22;

            @(posedge clk);
            write_enable = 0;
            read_enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Enable control", test_num);


            @(posedge clk);
            address = 16'hA000;
            data_in = 8'hCC;
            write_enable = 1;


            @(posedge clk);
            data_in = 8'hDD;
            write_enable = 0;

            @(posedge clk);
            read_enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Read Enable control", test_num);


            @(posedge clk);
            address = 16'h1111;
            data_in = 8'h33;
            write_enable = 1;


            @(posedge clk);
            write_enable = 0;
            read_enable = 1;
            @(posedge clk);
            #1;


            @(posedge clk);
            address = 16'h2222;
            data_in = 8'h44;
            write_enable = 1;
            read_enable = 0;


            @(posedge clk);
            write_enable = 0;
            read_enable = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Address independence", test_num);

            @(posedge clk);
            write_enable = 1;
            address = 16'h0001; data_in = 8'h01;
            @(posedge clk);
            address = 16'h0002; data_in = 8'h02;
            @(posedge clk);
            address = 16'h0003; data_in = 8'h03;

            @(posedge clk);
            write_enable = 0;
            read_enable = 1;
            address = 16'h0002;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_ram Testbench");
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
        $dumpvars(0,address, clk, data_in, read_enable, write_enable, data_out);
    end

endmodule
