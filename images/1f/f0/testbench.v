`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dirty;
    reg [3:0] frame_number;
    reg [1:0] page_number;
    reg read_write;
    reg reset;
    reg valid;
    wire [3:0] memory_out;
    wire page_fault;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
        .clk(clk),
        .dirty(dirty),
        .frame_number(frame_number),
        .page_number(page_number),
        .read_write(read_write),
        .reset(reset),
        .valid(valid),
        .memory_out(memory_out),
        .page_fault(page_fault)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            page_number = 0;
            read_write = 0;
            frame_number = 0;
            valid = 0;
            dirty = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Initial reset check for Page 0...");
            test_num = test_num + 1;
            reset_dut();

            page_number = 2'b00;
            read_write = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Update Page 0 on fault and verify access...");
            test_num = test_num + 1;
            reset_dut();


            page_number = 2'b00;
            read_write = 0;
            @(posedge clk);
            #2;


            valid = 1'b1;
            frame_number = 4'h5;
            dirty = 1'b0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Update Page 3 with Dirty bit set...");
            test_num = test_num + 1;
            reset_dut();


            page_number = 2'b11;
            read_write = 1'b1;
            @(posedge clk);
            #2;


            valid = 1'b1;
            frame_number = 4'hA;
            dirty = 1'b1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Verify isolation between entries...");
            test_num = test_num + 1;
            reset_dut();


            page_number = 2'b00;
            @(posedge clk);
            valid = 1'b1;
            frame_number = 4'h7;
            @(posedge clk);
            #2;


            page_number = 2'b01;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite existing Page 2 entry...");
            test_num = test_num + 1;
            reset_dut();


            page_number = 2'b10;
            @(posedge clk);
            valid = 1'b1;
            frame_number = 4'h1;
            dirty = 1'b0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h1, 1'b0);




            frame_number = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hF, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management Testbench");
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
        input [3:0] expected_memory_out;
        input expected_page_fault;
        begin
            if (expected_memory_out === (expected_memory_out ^ memory_out ^ expected_memory_out) &&
                expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault)) begin
                $display("PASS");
                $display("  Outputs: memory_out=%h, page_fault=%b",
                         memory_out, page_fault);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_out=%h, page_fault=%b",
                         expected_memory_out, expected_page_fault);
                $display("  Got:      memory_out=%h, page_fault=%b",
                         memory_out, page_fault);
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
        $dumpvars(0,clk, dirty, frame_number, page_number, read_write, reset, valid, memory_out, page_fault);
    end

endmodule
