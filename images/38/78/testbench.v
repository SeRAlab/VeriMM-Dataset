`timescale 1ns/1ps

module page_table_manager_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_write;
    reg rst;
    reg [31:0] virtual_address;
    wire page_fault;
    wire [31:0] physical_address;
    wire success;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    page_table_manager dut (
        .clk(clk),
        .read_write(read_write),
        .rst(rst),
        .virtual_address(virtual_address),
        .page_fault(page_fault),
        .physical_address(physical_address),
        .success(success)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        read_write = 0;
        virtual_address = 32'h0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Successful Read Operation", test_num);
        reset_dut();

        read_write = 0;
        virtual_address = 32'h0000_1000;


        repeat(2) @(posedge clk);



        #1;




        check_outputs(1'b0, 32'h0000_1000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Successful Write Operation", test_num);
        reset_dut();

        read_write = 1;
        virtual_address = 32'h0000_2000;

        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b0, 32'h0000_2000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Page Fault on Invalid Read", test_num);
        reset_dut();

        read_write = 0;

        virtual_address = 32'hFFFF_FFFF;

        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 32'h0000_0000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Page Fault on Invalid Write", test_num);
        reset_dut();

        read_write = 1;
        virtual_address = 32'hE000_0000;

        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b1, 32'h0000_0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Consecutive Read/Write Operations", test_num);
        reset_dut();


        read_write = 0;
        virtual_address = 32'h0000_A000;
        repeat(2) @(posedge clk);


        read_write = 1;
        virtual_address = 32'h0000_B000;
        repeat(2) @(posedge clk);


        #1;



        check_outputs(1'b0, 32'h0000_B000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Recovery Check", test_num);


        reset_dut();
        read_write = 0;
        virtual_address = 32'hFFFF_0000;
        repeat(2) @(posedge clk);


        reset_dut();


        #1;



        check_outputs(1'b0, 32'h0000_0000, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("page_table_manager Testbench");
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
        input expected_page_fault;
        input [31:0] expected_physical_address;
        input expected_success;
        begin
            if (expected_page_fault === (expected_page_fault ^ page_fault ^ expected_page_fault) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address) &&
                expected_success === (expected_success ^ success ^ expected_success)) begin
                $display("PASS");
                $display("  Outputs: page_fault=%b, physical_address=%h, success=%b",
                         page_fault, physical_address, success);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: page_fault=%b, physical_address=%h, success=%b",
                         expected_page_fault, expected_physical_address, expected_success);
                $display("  Got:      page_fault=%b, physical_address=%h, success=%b",
                         page_fault, physical_address, success);
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
        $dumpvars(0,clk, read_write, rst, virtual_address, page_fault, physical_address, success);
    end

endmodule
