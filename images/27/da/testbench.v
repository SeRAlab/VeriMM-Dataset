`timescale 1ns/1ps

module VMU_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg read;
    reg reset;
    reg [9:0] virtual_address;
    reg write;
    wire [31:0] data_out;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VMU dut (
        .clk(clk),
        .data_in(data_in),
        .read(read),
        .reset(reset),
        .virtual_address(virtual_address),
        .write(write),
        .data_out(data_out),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            read = 0;
            write = 0;
            virtual_address = 0;
            data_in = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write and Read from Valid Address", test_num);
            reset_dut();


            virtual_address = 10'h010;
            data_in = 32'hAAAA_BBBB;
            write = 1;
            @(posedge clk);
            #2;
            write = 0;


            read = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'hAAAA_BBBB, 1'b0);
            read = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to Invalid Address (Should trigger error)", test_num);
            reset_dut();

            virtual_address = 10'h3FF;
            data_in = 32'hFFFF_FFFF;
            write = 1;
            @(posedge clk);
            #2;



            #1;




            check_outputs(data_out, 1'b1);
            write = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Read from Invalid Address (Should trigger error)", test_num);
            reset_dut();

            virtual_address = 10'h3FE;
            read = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(data_out, 1'b1);
            read = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sequential Access to Multiple Addresses", test_num);
            reset_dut();


            virtual_address = 10'h001;
            data_in = 32'h1111_2222;
            write = 1;
            @(posedge clk); #2;
            write = 0;


            virtual_address = 10'h002;
            data_in = 32'h3333_4444;
            write = 1;
            @(posedge clk); #2;
            write = 0;


            virtual_address = 10'h001;
            read = 1;
            @(posedge clk); #2;

            #1;


            check_outputs(32'h1111_2222, 1'b0);
            read = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Persistence and Read-after-Write", test_num);
            reset_dut();

            virtual_address = 10'h020;
            data_in = 32'hCAFE_BABE;
            write = 1;
            @(posedge clk); #2;
            write = 0;

            repeat(5) @(posedge clk);

            virtual_address = 10'h020;
            read = 1;
            @(posedge clk); #2;

            #1;


            check_outputs(32'hCAFE_BABE, 1'b0);
            read = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VMU Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_data_out;
        input expected_error;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, error=%b",
                         data_out, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, error=%b",
                         expected_data_out, expected_error);
                $display("  Got:      data_out=%h, error=%b",
                         data_out, error);
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
        $dumpvars(0,clk, data_in, read, reset, virtual_address, write, data_out, error);
    end

endmodule
