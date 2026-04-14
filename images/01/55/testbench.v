`timescale 1ns/1ps

module virtual_memory_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] data_in;
    reg reset;
    reg rw;
    reg [1:0] virtual_address;
    wire [1:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_manager dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .rw(rw),
        .virtual_address(virtual_address),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rw = 0;
            virtual_address = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            rw = 1;
            virtual_address = 2'b01;
            data_in = 2'b10;


            @(posedge clk);
            rw = 0;
            virtual_address = 2'b01;


            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset State", test_num);
            reset_dut();


            @(posedge clk);
            rw = 0;
            virtual_address = 2'b10;


            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Mapping", test_num);
            reset_dut();


            @(posedge clk);
            rw = 1;
            virtual_address = 2'b00;
            data_in = 2'b01;


            @(posedge clk);
            rw = 1;
            virtual_address = 2'b00;
            data_in = 2'b11;


            @(posedge clk);
            rw = 0;
            virtual_address = 2'b00;


            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Fill Page Table", test_num);
            reset_dut();


            @(posedge clk); rw = 1; virtual_address = 2'b00; data_in = 2'b00;
            @(posedge clk); rw = 1; virtual_address = 2'b01; data_in = 2'b01;
            @(posedge clk); rw = 1; virtual_address = 2'b10; data_in = 2'b10;
            @(posedge clk); rw = 1; virtual_address = 2'b11; data_in = 2'b11;


            @(posedge clk);
            rw = 0;
            virtual_address = 2'b11;


            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Persistent Storage Check", test_num);
            reset_dut();


            @(posedge clk);
            rw = 1;
            virtual_address = 2'b10;
            data_in = 2'b01;


            @(posedge clk);
            rw = 0;
            virtual_address = 2'b10;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_manager Testbench");
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
        input [1:0] expected_data_out;
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,clk, data_in, reset, rw, virtual_address, data_out, valid);
    end

endmodule
